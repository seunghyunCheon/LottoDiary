//
//  LottoValidationController.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Combine
import Foundation

protocol LottoValidationFlowProtocol {
    func updateLottosWithNoResult()
}

final class LottoValidationController: LottoValidationFlowProtocol {

    private let lottoValidationUseCase: LottoValidationUseCase

    private var roundNumberSet: [Int: [[Int]]] = [:]

    private var cancellables = Set<AnyCancellable>()

    init(lottoValidationUseCase: LottoValidationUseCase) {
        self.lottoValidationUseCase = lottoValidationUseCase
    }

    func updateLottosWithNoResult() {
        // 1. 당첨 결과가 없는 로또 fetch
        lottoValidationUseCase.fetchLottosWithoutWinningAmount()
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { lottos in
                lottos.forEach { lotto in
                    if let result = self.roundNumberSet[lotto.roundNumber] {
                        // 이미 해당 회차번호에 대한 결과값이 있을 경우, 번호 비교
                        return self.updateWinningAmount(lotto, result: result)
                    } else {
                        // 결과가 아직 오지 않은 경우, 결과 조회
                        return self.fetchLottoResult(lotto)
                            .sink { completion in
                                if case .failure(let error) = completion {
                                    print(error.localizedDescription)
                                }
                            } receiveValue: { result in
                                return self.updateWinningAmount(lotto, result: result)
                            }
                            .store(in: &self.cancellables)
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func updateWinningAmount(_ lotto: Lotto, result: [[Int]]) {
        let comparedNumbers = self.compareLottoNumbers(lotto.lottoNumbers, with: result[0], bonus: result[1])
        let amount = self.calculateWinningAmount(numbers: comparedNumbers)
        return self.lottoValidationUseCase.updateWinningAmount(lotto: lotto, amount: amount)
    }

    private func fetchLottoResult(_ lotto: Lotto) -> AnyPublisher<[[Int]], Error> {
        return lottoValidationUseCase.fetchLottoResult(lotto.roundNumber)
            .map { result in
                // 아직 결과가 안나온거라면 끝!
                guard let result = result else { return nil }
                // 결과 나왔을 때 아래 실행
                print("새로 네트워킹 해서 결과 받아왔어요!")
                self.roundNumberSet[lotto.roundNumber] = result
                return result
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
    }

    private func calculateWinningAmount(numbers: [Int?]) -> Int {
        let winningAmounts = numbers.compactMap { number in
            switch number {
            case 3:
                print("5등 금액")
               return 5000
            case 4:
                print("4등 금액")
               return 50000
            case 5:
                print("네트워킹 통한 3등 금액")
                return 100000
            case -5:
                print("네트워킹 통한 2등 금액")
                return 200000
            case 6:
                print("네트워킹 통한 1등 금액")
                return 3000000
            default:
                break
            }
            return number
        }

        return winningAmounts.reduce(0, +)
    }

    private func compareLottoNumbers(_ numbers: [[Int]], with result: [Int], bonus: [Int]) -> [Int?] {
        // 로또 번호와 결과 비교 로직 구현
        let comparedNumbers = numbers.map { number in
            let count = Set(number).intersection(Set(result)).count
            if count == 5 && number.contains(bonus[0]) {
                // 번호 5개 + 보너스 번호까지 있으면 "-5" (2등)
                return Optional(-5)
            } else {
                return count > 2 ? count : nil
            }
        }
        return comparedNumbers
    }
}
