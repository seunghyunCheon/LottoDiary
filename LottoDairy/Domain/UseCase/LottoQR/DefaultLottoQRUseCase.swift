//
//  DefaultLottoQRUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 10/19/23.
//

import Foundation
import Combine
import SwiftSoup

extension String {
    func encoding() -> String? {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
    
    func decoding() -> String? {
        self.removingPercentEncoding
    }
}

enum LottoQRUseCaseError: Error {
    case emptyURL
    case invalidURL
    case invalidResponse
    case invalidEncoding
}

final class DefaultLottoQRUseCase: LottoQRUseCase {
    
    private let lottoRepository: LottoRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(lottoRepository: LottoRepository) {
        self.lottoRepository = lottoRepository
    }

    // QR코드로 받아온 string이 로또 주소가 맞는지 확인하는 함수
    func valid(_ url: String) -> Bool {
        // 로또 번호 주소가 올바르지 않을 경우
        return url.contains(LottoAPI.baseURL)
    }

    func crawlLottoResult(_ url: String) -> AnyPublisher<Lotto, Error> {
        // 1. url을 통해 크롤링한다.
        // 2. 정보를 기반으로 로또를 생성하고 반환한다.
        // 3. 외부에서 당첨금액이 없다면 달력으로 화면을 이동하고, 당첨금액이 있다면 당첨화면을 보여준다.

        guard let url = URL(string: url) else {
            return Fail(error: LottoQRUseCaseError.emptyURL).eraseToAnyPublisher()
        }
        return crawlling(url: url)
    }
    
    private func crawlling(url: URL) -> AnyPublisher<Lotto, Error> {
//        var redirectedUrl = url.replacingOccurrences(of: "/?", with: "/qr.do?&method=winQr&")
//        
//        if let range = redirectedUrl.range(of: "/qr.do?") {
//            let lottoHost = "http://m.dhlottery.co.kr/"
//            let pathAndQuery = String(redirectedUrl[range.lowerBound...])
//            redirectedUrl = lottoHost + pathAndQuery
//        }
//        guard let url = URL(string: redirectedUrl) else {
//            return Fail(error: LottoQRUseCaseError.invalidURL).eraseToAnyPublisher()
//        }

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw LottoQRUseCaseError.invalidResponse
                }
                return element.data
            }
            .flatMap { data -> AnyPublisher<Lotto, Error> in
                do {
                    let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
                    if let html = String(data: data, encoding: String.Encoding(rawValue: encodingEUCKR)) {
                        let doc: Document = try SwiftSoup.parse(html)
                        let purchaseCounts: Elements = try doc.select(".tbl_basic").select("tr")
                        let winningAmounts: Elements = try doc.select(".bx_notice").select(".key_clr1")
                        let lottoNumbers: Elements = try doc.select(".list_my_number").select("tbody").select(".clr").select("span")
                        let roundNumberInformation: String = try doc.select(".winner_number").select(".key_clr1").get(0).text()
                        let winningNumbers: Elements = try doc.select(".bx_winner").select(".list")
                        
                        var myLottoNumbers: [String] = []
                        for number in lottoNumbers {
                            myLottoNumbers.append(try number.text())
                        }
                        
                        let roundNumber = self.convertToRoundNumber(roundNumberInformation)
                        let separatedLottoNumbers = self.convertToSeparatedLottoNumbers(myLottoNumbers)
                        
                        if !winningNumbers.isEmpty() {
                            let winningAmountInformation = try winningAmounts.text()
                            let lotto = Lotto(
                                purchaseAmount: 1000*purchaseCounts.count,
                                winningAmount: self.convertToWinningAmount(winningAmountInformation),
                                lottoNumbers: separatedLottoNumbers,
                                roundNumber: roundNumber
                            )
                            
                            return self.lottoRepository.saveLotto(lotto)
                        } else {
                            let lotto = Lotto(
                                purchaseAmount: 1000*purchaseCounts.count,
                                winningAmount: -1,
                                lottoNumbers: separatedLottoNumbers,
                                roundNumber: roundNumber
                            )
                            
                            return self.lottoRepository.saveLotto(lotto)
                        }
                    } else {
                        return Fail(error: LottoQRUseCaseError.invalidEncoding).eraseToAnyPublisher()
                    }
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
    
    private func convertToWinningAmount(_ winningAmount: String) -> Int {
        return Int(winningAmount.filter { $0.isNumber }) ?? 0
    }
    
    private func convertToSeparatedLottoNumbers(_ lottoNumbers: [String]) -> [[Int]] {
        var separatedLottoNumbers: [[Int]] = []
        var idx = 0
        
        while idx < lottoNumbers.count {
            let array = Array(lottoNumbers[idx..<idx+6]).map { Int($0) ?? 0 }
            separatedLottoNumbers.append(array)
            idx += 6
        }
        
        return separatedLottoNumbers
    }
    
    private func convertToRoundNumber(_ roundNumberInformation: String) -> Int {
        return Int(roundNumberInformation.filter { $0.isNumber }) ?? 0
    }
}

