//
//  ChartUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/11.
//

import DGCharts
import Combine

protocol ChartUseCase {
    func makeBarChartData(year: Int) -> AnyPublisher<BarChartData, Error>
}
