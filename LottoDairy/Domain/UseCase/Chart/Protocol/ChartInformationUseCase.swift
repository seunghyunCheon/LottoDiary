//
//  ChartInformationUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Combine

protocol ChartInformationUseCase {
    func makeRangeOfYear() -> AnyPublisher<[Int], Error>
    func makeYearAndMonthOfToday() -> [Int]
    func makeChartInformationComponents(year: Int, month: Int) -> AnyPublisher<[ChartInformationComponents], Never>
}
