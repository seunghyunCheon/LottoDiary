//
//  DefaultChartLottoUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/19.
//

import Foundation
import Combine

fileprivate enum ChartLottoUseCaseError: LocalizedError {
    case failedToCreateDate

    var errorDescription: String? {
        switch self {
        case .failedToCreateDate:
            return "Calendar의 날짜 생성에 실패했습니다."
        }
    }
}

final class DefaultChartLottoUseCase: ChartLottoUseCase {

    private let lottoRepository: LottoRepository

    private let calendar = Calendar.current

    init(lottoRepository: LottoRepository) {
        self.lottoRepository = lottoRepository
    }

    func fetchLottoAmounts(year: Int, month: Int) -> AnyPublisher<(purchase: Int?, winning: Int?), Error> {
        return fetchLottoEntries(year: year, month: month)
            .flatMap { lottos -> AnyPublisher<(purchase: Int?, winning: Int?), Error> in
                let purchaseAmount = lottos?.reduce(into: 0) { pre, next in
                    pre += next.purchaseAmount
                }
                let winningAmount = lottos?.reduce(into: 0) { pre, next in
                    pre += next.winningAmount
                }
                return Just((purchase: purchaseAmount, winning: winningAmount))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func calculateNetAmount(year: Int, month: Int) -> AnyPublisher<Int?, Error> {
        return fetchLottoAmounts(year: year, month: month)
            .flatMap { (purchaseAmount, winningAmount) -> AnyPublisher<Int?, Error> in
                guard let purchaseAmount = purchaseAmount, let winningAmount = winningAmount else {
                    return Just<Int?>(nil)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
                return Just(purchaseAmount - winningAmount)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    private func fetchLottoEntries(year: Int) -> AnyPublisher<[Lotto]?, Error> {
        let startComponents = DateComponents(year: year, month: 1, day: 1)
        let endComponents = DateComponents(year: year, month: 12, day: 31)

        guard let startDate = self.calendar.date(from: startComponents),
              let endDate = self.calendar.date(from: endComponents) else {
            return Fail<[Lotto]?, Error>(error: ChartLottoUseCaseError.failedToCreateDate)
                .eraseToAnyPublisher()
        }

        return lottoRepository.fetchLottos(with: startDate, and: endDate)
            .flatMap { lottos in
                if lottos.isEmpty {
                    return Just<[Lotto]?>(nil).setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } else {
                    return Just(lottos).setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }

    private func fetchLottoEntries(year: Int, month: Int) -> AnyPublisher<[Lotto]?, Error> {
        return fetchLottoEntries(year: year)
            .map { [weak self] lottos in
                return lottos?.filter { lotto in
                    let lottoMonth = self?.calendar.component(.month, from: lotto.date)
                    return lottoMonth == month
                }
            }
            .eraseToAnyPublisher()
    }
}