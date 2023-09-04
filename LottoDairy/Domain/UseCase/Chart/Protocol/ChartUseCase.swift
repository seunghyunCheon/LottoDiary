//
//  ChartUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Combine

protocol ChartUseCase {
    func makeRangeOfYear() -> AnyPublisher<[Int], Never>
    func makeYearAndMonthOfToday() -> AnyPublisher<[Int], Never>
}
