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
    case outOfResponseCode
    case failedToEncoding
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
        return lottoURL(url)
            .flatMap { url -> AnyPublisher<Lotto, Error> in
                return self.crawlling(url: url)
            }
            .eraseToAnyPublisher()
    }

    private func lottoURL(_ url: String) -> AnyPublisher<URL, Error> {
        var redirectedUrl = url.replacingOccurrences(of: "/?", with: "/qr.do?&method=winQr&")
        if let range = redirectedUrl.range(of: "/qr.do?") {
            let lottoHost = "\(LottoAPI.baseURL)/"
            let pathAndQuery = String(redirectedUrl[range.lowerBound...])
            redirectedUrl = lottoHost + pathAndQuery
        }
        guard let url = URL(string: redirectedUrl) else {
            return Fail(error: LottoQRUseCaseError.emptyURL).eraseToAnyPublisher()
        }

        #if DEBUG
        print("✅ 로또QR로 받아온 string url -> URL 타입 변환 성공")
        print("-----------------------------------------")
        #endif

        return Just(url)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    private func crawlling(url: URL) -> AnyPublisher<Lotto, Error> {
        #if DEBUG
        print("ℹ️ 동행복권 결과 페이지 크롤링 시작")
        print("-----------------------------------------")
        #endif

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .tryMap { element -> Data in
                guard element.response.checkResponse else {
                    throw LottoQRUseCaseError.outOfResponseCode
                }
                return element.data
            }
            .flatMap { data -> AnyPublisher<Lotto, Error> in
                do {
                    let htmlSting = try self.encode(data)
                    return try self.saveLotto(htmlSting)
                } catch {
                    return Fail(error: error).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    /// 크롤링으로 받아온 데이터 String 타입으로 encoding 하는 함수
    private func encode(_ data: Data) throws -> String {
        let encodingEUCKR = CFStringConvertEncodingToNSStringEncoding(0x0422)
        guard let html = String(data: data, encoding: String.Encoding(rawValue: encodingEUCKR)) else {
            throw LottoQRUseCaseError.failedToEncoding
        }
        #if DEBUG
        print("✅ 동행복권 html data -> String encoding 성공!")
        print("-----------------------------------------")
        #endif

        return html
    }

    private func saveLotto(_ html: String) throws -> AnyPublisher<Lotto, Error> {
        let doc: Document = try SwiftSoup.parse(html)
        let purchaseCounts: Elements = try doc.purchase()
        let winningNumbers: Elements = try doc.winningNumbers()
        let winningAmount: Int = try doc.winningAmount()
        let roundNumber = try doc.roundNumber()
        let lottoNumbers: [[Int]] = try doc.lottoNumbers()

        if !winningNumbers.isEmpty() {
            let lotto = Lotto(
                purchaseAmount: 1000 * purchaseCounts.count,
                winningAmount: winningAmount,
                lottoNumbers: lottoNumbers,
                roundNumber: roundNumber
            )
            #if DEBUG
            print("✅ 이미 결과가 나온, 새로운 로또 인스턴스 생성 완료! \n✅\(lotto)")
            print("-----------------------------------------")
            #endif

            return self.lottoRepository.saveLotto(lotto)
        } else {
            let lotto = Lotto(
                purchaseAmount: 1000 * purchaseCounts.count,
                winningAmount: -1,
                lottoNumbers: lottoNumbers,
                roundNumber: roundNumber
            )
            #if DEBUG
            print("✅ 아직 결과 안나온, 새로운 로또 인스턴스 생성 완료! \n✅\(lotto)")
            print("-----------------------------------------")
            #endif

            return self.lottoRepository.saveLotto(lotto)
        }
    }
}

fileprivate extension Document {
    func purchase() throws -> Elements {
        return try self.select(".tbl_basic").select("tr")
    }

    func winningNumbers() throws -> Elements {
        return try self.select(".bx_winner").select(".list")
    }

    func lottoNumbers() throws -> [[Int]] {
        let numbers: Elements = try self.numbers()
        let lottoNumbers = try numbers.map { try Int($0.text()) }.compactMap { $0 }

        var separatedNumbers: [[Int]] = []
        for idx in stride(from: 0, to: lottoNumbers.count, by: 6) {
            let endIndex = min(idx + 6, lottoNumbers.count)
            separatedNumbers.append(Array(lottoNumbers[idx..<endIndex]))
        }

        return separatedNumbers
    }

    func roundNumber() throws -> Int {
        let roundNumberString: String = try self.roundNumber().get(0).text()
        return Int(roundNumberString.filter { $0.isNumber }) ?? 0
    }

    func winningAmount() throws -> Int {
        let winning: String = try self.winning().text()
        return Int(winning.filter { $0.isNumber }) ?? 0
    }

    private func numbers() throws -> Elements {
        return try self.select(".list_my_number").select("tbody").select(".clr").select("span")
    }

    private func roundNumber() throws -> Elements {
        return try self.select(".winner_number").select(".key_clr1")
    }

    private func winning() throws -> Elements {
        return try self.select(".bx_notice").select(".key_clr1")
    }
}
