//
//  ChartLottoUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/19.
//

import Foundation
import Combine

protocol ChartLottoUseCase {
    func fetchLottoEntries(year: Int, month: Int) -> AnyPublisher<[Lotto], Error>
    func makeChartInformationComponentsAccount(year: Int, month: Int) -> AnyPublisher<(purchase: Int, winning: Int), Error>
}
