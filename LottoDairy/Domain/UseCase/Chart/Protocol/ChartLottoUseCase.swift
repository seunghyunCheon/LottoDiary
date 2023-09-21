//
//  ChartLottoUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/19.
//

import Foundation
import Combine

protocol ChartLottoUseCase {
    func fetchLottoAmounts(year: Int, month: Int) -> AnyPublisher<(purchase: Int?, winning: Int?), Error>
    func calculateNetAmount(year: Int, month: Int) -> AnyPublisher<Int?, Error>
}
