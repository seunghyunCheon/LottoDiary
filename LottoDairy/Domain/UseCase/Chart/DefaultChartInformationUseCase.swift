//
//  DefaultChartInformationUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Foundation
import Combine

final class DefaultChartInformationUseCase: ChartInformationUseCase {

    private let userRepository: UserRepository

    private let chartLottoUseCase: ChartLottoUseCase

    private let calendar = Calendar.current

    init(userRepository: UserRepository, chartLottoUseCase: ChartLottoUseCase) {
        self.userRepository = userRepository
        self.chartLottoUseCase = chartLottoUseCase
    }

    func makeRangeOfYears() -> [Int] {
        let thisYear = self.calendar.component(.year, from: .today)
        let range = (thisYear - 10)...thisYear

        return Array(range)
    }

    func makeYearAndMonthOfToday() -> [Int] {
        let year = self.calendar.component(.year, from: .today)
        let month = self.calendar.component(.month, from: .today)

        return [year, month]
    }

    func makeChartInformationComponents(year: Int, month: Int) -> AnyPublisher<[ChartInformationComponents], Error> {
        return Publishers.CombineLatest(
            chartLottoUseCase.fetchLottoAmounts(year: year, month: month),
            userRepository.fetchGoalAmount()
        )
        .map { (lottoAmount, goalAmount) -> [ChartInformationComponents] in
            let (purchaseAmount, winningAmount) = lottoAmount
            
            let goalResult: Bool = goalAmount >= purchaseAmount
            let winResult: Bool = purchaseAmount <= winningAmount
            var percent: Double = 0
            if winningAmount == 0 && purchaseAmount == 0 {
                percent = 0
            } else {
                percent = Double(winningAmount) / Double(purchaseAmount) * 100
            }

            let chartInformationComponents = [
                ChartInformationComponents(
                    type: .goal,
                    amount: goalAmount,
                    result: (goalResult, nil)
                ),
                ChartInformationComponents(
                    type: .buy,
                    amount: purchaseAmount,
                    result: (goalResult, nil)
                ),
                ChartInformationComponents(
                    type: .win,
                    amount: winningAmount,
                    result: (winResult, Int(percent))
                )
            ]

            return chartInformationComponents
        }
        .eraseToAnyPublisher()
    }
}
