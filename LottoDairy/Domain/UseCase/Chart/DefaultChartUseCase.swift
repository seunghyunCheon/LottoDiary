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

    private func makeChartComponents(year: Int) -> AnyPublisher<[ChartComponents]?, Error> {
        let componentsPublisher = (1...12).map { month in
            return chartLottoUseCase.calculateNetAmount(year: year, month: month)
                .map { netAmount -> ChartComponents? in
                    guard let netAmount = netAmount else {
                        return nil
                    }

                    return ChartComponents(month: month, account: Double(netAmount))
                }
                .eraseToAnyPublisher()
        }

        return Publishers.MergeMany(componentsPublisher)
            .collect()
            .map { components -> [ChartComponents]? in
                if components.contains(where: { $0 == nil }) {
                    return nil
                }

                return components.compactMap { $0 }
            }
            .eraseToAnyPublisher()
    }

    private func makeBarChartDataEntry(year: Int) -> AnyPublisher<[BarChartDataEntry]?, Error> {
        return makeChartComponents(year: year)
            .map { chartComponents in
                guard let chartComponents = chartComponents else {
                    return nil
                }

                return chartComponents.map { chartComponent in
                    BarChartDataEntry(x: Double(chartComponent.month), y: chartComponent.account)
                }
            }
            .eraseToAnyPublisher()
    }

    private func makeBarChartDataSet(year: Int) -> AnyPublisher<BarChartDataSet?, Error> {
        return makeBarChartDataEntry(year: year)
            .map { barChartDataEntry in
                guard let barChartDataEntry = barChartDataEntry else {
                    return nil
                }
                let dataSet = BarChartDataSet(entries: barChartDataEntry)
                dataSet.colors = [ .designSystem(.mainBlue) ?? .systemBlue ]
                dataSet.drawValuesEnabled = false

                return dataSet
            }
            .eraseToAnyPublisher()
    }

    func makeBarChartData(year: Int) -> AnyPublisher<BarChartData?, Error> {
        return makeBarChartDataSet(year: year)
            .map { barChartDataSet in
                guard let barChartDataSet = barChartDataSet else {
                    return nil
                }
                
                return BarChartData(dataSet: barChartDataSet)
            }
            .eraseToAnyPublisher()
    }
}
