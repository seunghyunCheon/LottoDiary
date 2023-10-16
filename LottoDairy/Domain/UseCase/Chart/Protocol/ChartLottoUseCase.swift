//
//  ChartLottoUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/19.
//

import Combine

protocol ChartLottoUseCase {
    func fetchToday() -> [Int]
    func fetchLottoAmounts(year: Int, month: Int) -> AnyPublisher<(purchase: Int?, winning: Int?), Error>
    func calculateNetAmount(year: Int, month: Int) -> AnyPublisher<Int?, Error>
    func calculatePercent(_ a: Int?, _ b: Int?) -> Int
}
