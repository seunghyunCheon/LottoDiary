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
        return Future<[ChartComponents], Error> { promise in
            var chartComponentsOfYear = [ChartComponents]()

            // Repository: CoreData에서 특정 년도에 속한 데이터 로드하기
            for month in 1...12 {
                // 아마 배열 형태로 반환..
                //            let lottoData = repository.fetchLottoItem(year: year, month: month)

                let account = (1000...200000).randomElement()
                let component = ChartComponents(month: month, account: Double(account!))
                chartComponentsOfYear.append(component)
            }

            promise(.success(chartComponentsOfYear))
        }
        .eraseToAnyPublisher()
            // 특정 년/월에 해당하는 로또 데이터가 배열 형태로 온다면, reduce 등을 사용해 한달 총 구매 금액 - 당첨 금액으로 account 구하기
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
