//
//  ChartInformationUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Combine

protocol ChartInformationUseCase {
    func makeRangeOfYears() -> [Int]
    func makeYearAndMonthOfToday() -> [Int]
    func makeChartInformationComponents(year: Int, month: Int) -> AnyPublisher<[ChartInformationComponents], Error>
}
