//
//  DefaultChartUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/11.
//

import Combine
import DGCharts

final class DefaultChartUseCase: ChartUseCase {

    private let chartLottoUseCase: ChartLottoUseCase

    init(chartLottoUseCase: ChartLottoUseCase) {
        self.chartLottoUseCase = chartLottoUseCase
    }

    private func makeChartComponents(year: Int) -> AnyPublisher<[ChartComponents], Error> {
        let componentsPublisher = (1...12).map { month in
            return chartLottoUseCase.calculateNetAmount(year: year, month: month)
                .map { netAmount -> ChartComponents in
                    return ChartComponents(month: month, account: Double(netAmount))
                }
                .eraseToAnyPublisher()
        }

        return Publishers.MergeMany(componentsPublisher)
            .collect()
            .eraseToAnyPublisher()
    }

    private func makeBarChartDataEntry(year: Int) -> AnyPublisher<[BarChartDataEntry], Error> {
        return makeChartComponents(year: year)
            .map { chartComponents in
                chartComponents.map { chartComponent in
                    BarChartDataEntry(x: Double(chartComponent.month), y: chartComponent.account)
                }
            }
            .eraseToAnyPublisher()
    }

    private func makeBarChartDataSet(year: Int) -> AnyPublisher<BarChartDataSet, Error> {
        return makeBarChartDataEntry(year: year)
            .map { barChartDataEntry in
                let dataSet = BarChartDataSet(entries: barChartDataEntry)
                dataSet.colors = [ .designSystem(.mainBlue) ?? .systemBlue ]
                dataSet.drawValuesEnabled = false
                return dataSet
            }
            .eraseToAnyPublisher()
    }

    func makeBarChartData(year: Int) -> AnyPublisher<BarChartData, Error> {
        return makeBarChartDataSet(year: year)
            .map { barChartDataSet in
                BarChartData(dataSet: barChartDataSet)
            }
            .eraseToAnyPublisher()
    }
}
