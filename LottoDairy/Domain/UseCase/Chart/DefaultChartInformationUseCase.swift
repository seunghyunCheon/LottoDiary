//
//  DefaultChartInformationUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Foundation
import Combine

final class DefaultChartInformationUseCase: ChartInformationUseCase {

    private let lottoRepository: LottoRepository

    private let chartLottoUseCase: ChartLottoUseCase

    private let calendar = Calendar.current

    init(lottoRepository: LottoRepository, chartLottoUseCase: ChartLottoUseCase) {
        self.lottoRepository = lottoRepository
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
        return chartLottoUseCase.makeChartInformationComponentsAccount(year: year, month: month)
            .map { (purchaseAmount, winningAmount) -> [ChartInformationComponents] in
                // repository에서 특정 월에 대한 목표 금액 가져오기
                let goalAmount = (1...30000).randomElement()!

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
