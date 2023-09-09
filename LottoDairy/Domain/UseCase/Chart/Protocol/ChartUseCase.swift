//
//  ChartUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Combine
import DGCharts

protocol ChartUseCase {
    func makeRangeOfYear() -> AnyPublisher<[Int], Never>
    func makeYearAndMonthOfToday() -> [Int]
    func makeChartInformationComponents(year: Int, month: Int) -> AnyPublisher<[ChartInformationComponents], Never>
    func makeBarChartData(year: Int) -> AnyPublisher<BarChartData, Never>
}
