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
    case invalidURL
    case invalidResponse
}

final class DefaultLottoQRUseCase: LottoQRUseCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func validateLottoURL(_ url: String) -> Bool {
        return url.contains(LottoAPI.baseURL)
    }
    
    func crawlLottoResult(_ url: String) -> AnyPublisher<Lotto, Error> {
        // 1. url을 통해 크롤링한다.
        // 2. 정보를 기반으로 로또를 생성하고 반환한다.
        // 3. 외부에서 당첨금액이 없다면 달력으로 화면을 이동하고, 당첨금액이 있다면 당첨화면을 보여준다.
        
        crawlling(url: url)
            .sink(receiveCompletion: { comp in
                if case .failure(let error) = comp {
                    print(error)
                }
            }, receiveValue: { str in
                
            })
            .store(in: &cancellables)
        
        return Fail(error: LottoQRUseCaseError.invalidURL).eraseToAnyPublisher()
    }
    
    private func crawlling(url: String) -> AnyPublisher<String, Error> {
        var redirectedUrl = url.replacingOccurrences(of: "/?", with: "/qr.do?&method=winQr&")
        
        if let range = redirectedUrl.range(of: "/qr.do?") {
            let lottoHost = "http://m.dhlottery.co.kr/"
            let pathAndQuery = String(redirectedUrl[range.lowerBound...])
            redirectedUrl = lottoHost + pathAndQuery
        }
        print(redirectedUrl)
        guard let url = URL(string: redirectedUrl) else {
            return Fail(error: LottoQRUseCaseError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard let httpResponse = element.response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw LottoQRUseCaseError.invalidResponse
                }
                return element.data
            }
            .flatMap { data -> AnyPublisher<String, Error> in
                do {
                    let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
                    if let html = String(data: data, encoding: String.Encoding(rawValue: encodingEUCKR)) {
                        let doc: Document = try SwiftSoup.parse(html)
                        let isAnnounced: Elements = try doc.select(".winner_number").select(".tit")
                        let lottoNumbers: Elements = try doc.select(".bx_winner").select(".list").select(".clr").select("span")
                        let purchaseCounts: Elements = try doc.select(".tbl_basic").select("tr")
                        let winningAmount: Elements = try doc.select(".bx_notice").select(".key_clr1")
                        
                        // 결과발표가 일어났다면
                        if !isAnnounced.isEmpty() {
                            var myLottoNumbers = []
                            for number in lottoNumbers {
                                myLottoNumbers.append(try number.text())
                            }
                            // 구매금액, 당첨금액, 내 로또번호 이렇게 세개만 넘겨주면 된다.
                            print(myLottoNumbers)
                            print(try winningAmount.text())
                            print(purchaseCounts.count)
                        } else {
                            // 여기서는 당첨금액을 -1로 구매금액, 로또번호 이렇게 세개 넘겨준다.
                        }
                    }
                    return Just("")
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

