//
//  DefaultChartLottoUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/19.
//

import Foundation
import Combine

fileprivate enum ChartLottoUseCaseError: LocalizedError {
    case failedToMakeCalendarDate

    var errorDescription: String? {
        switch self {
        case .failedToMakeCalendarDate:
            return "Calendar의 날짜 생성에 실패했습니다."
        }
    }
}

final class DefaultChartLottoUseCase: ChartLottoUseCase {

    private let lottoRepository: LottoRepository

    init(lottoRepository: LottoRepository) {
        self.lottoRepository = lottoRepository
    }

    private func fetchLottoEntries(year: Int, month: Int) -> AnyPublisher<[Lotto], Error> {
        let calendar = Calendar.current
        var components = DateComponents(year: year, month: month, day: 1)

        guard let startDate = calendar.date(from: components) else {
            return Fail<[Lotto], Error>(error: ChartLottoUseCaseError.failedToMakeCalendarDate)
                .eraseToAnyPublisher()
        }
        components.month = month + 1
        guard let nextMonthDate = calendar.date(from: components),
              let endDate = calendar.date(byAdding: .day, value: -1, to: nextMonthDate) else {
            return Fail<[Lotto], Error>(error: ChartLottoUseCaseError.failedToMakeCalendarDate)
                .eraseToAnyPublisher()
        }

        return lottoRepository.fetchLottos(with: startDate, and: endDate)
    }

    func calculateNetAmount(year: Int, month: Int) -> AnyPublisher<Int, Error> {
        return fetchLottoAmounts(year: year, month: month)
            .flatMap { (purchaseAmount, winningAmount) -> AnyPublisher<Int, Error> in
                return Just(purchaseAmount - winningAmount)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func fetchLottoAmounts(year: Int, month: Int) -> AnyPublisher<(purchase: Int, winning: Int), Error> {
        return fetchLottoEntries(year: year, month: month)
            .flatMap { lottos -> AnyPublisher<(purchase: Int, winning: Int), Error> in
                let purchaseAmount = lottos.reduce(into: 0) { pre, next in
                    pre += next.purchaseAmount
                }
                let winningAmount = lottos.reduce(into: 0) { pre, next in
                    pre += next.winningAmount
                }
                return Just((purchase: purchaseAmount, winning: winningAmount))
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
