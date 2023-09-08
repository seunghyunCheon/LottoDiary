//
//  DefaultChartUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Foundation
import Combine
import DGCharts

final class DefaultChartUseCase: ChartUseCase {

//    private let repository: CoreDataRepository

//    init(repository: CoreDataRepository) {
//        self.repository = repository
//    }

    // MARK: ChartInformation 관련 함수
    // Repository: CoreData에 저장되어있는 가장 오래된 데이터의 년도 조회
    // UseCase: Repository의 오래된 년도 조회 함수의 return값 ~ 현재 년도까지 [Int] 배열 반환하는 함수
    func makeRangeOfYear() -> AnyPublisher<[Int], Never> {
        return Future<[Int], Never> { promise in
            // 비동기로 CoreData에서 oldestYear fetch하는 함수 실행
            //        let oldestYear = repository.fetchOldestYear()
            let oldestYear = 2021
            let thisYear = Calendar.current.component(.year, from: Date())

            var years = [Int]()
            for year in oldestYear...thisYear {
                years.append(year)
            }

            promise(.success(years))
        }
        .eraseToAnyPublisher()
    }

    // 첫 chart scene에서 dateHeaderTextField가 오늘 년/월을 보여줄 수 있도록 현재 년/월 반환하는 함수
    func makeYearAndMonthOfToday() -> AnyPublisher<[Int], Never> {
        return Just(())
            .map {
                let year = Calendar.current.component(.year, from: Date())
                let month = Calendar.current.component(.month, from: Date())
                return [year, month]
            }
            .eraseToAnyPublisher()
    }

    // MARK: ChartView 관련 함수

    // 데이터가 없는 월이라도 ChartComponents가 1월부터 12월까지 다 있어야 차트에서 일년치를 볼 수 있음.
    // 1년치의 ChartComponents를 만드는 함수
    private func makeChartComponents(year: Int) -> [ChartComponents] {
        var chartComponentsOfYear = [ChartComponents]()

        // Repository: CoreData에서 특정 년도에 속한 데이터 로드하기
        for month in 1...12 {
            // 아마 배열 형태로 반환..
//            let lottoData = repository.fetchLottoItem(year: year, month: month)
            // 특정 년/월에 해당하는 로또 데이터가 배열 형태로 온다면, reduce 등을 사용해 한달 총 구매 금액 - 당첨 금액으로 account 구하기
            let account = (1000...200000).randomElement()
            let component = ChartComponents(month: month, account: Double(account!))
            chartComponentsOfYear.append(component)
        }

        return chartComponentsOfYear
    }

    // 1. BarChartDataEntry 생성
    private func makeBarChartDataEntry(year: Int) -> [BarChartDataEntry] {
        let chartComponents = makeChartComponents(year: year)
        let dataEntry = chartComponents.map { component in
            BarChartDataEntry(x: Double(component.month), y: component.account)
        }

        return dataEntry
    }

    // 2. BarChartSet 생성
    private func makeBarChartDataSet(_ dataEntry: [BarChartDataEntry]) -> BarChartDataSet {
        let dataSet = BarChartDataSet(entries: dataEntry)
        dataSet.colors = [ .designSystem(.mainBlue) ?? .systemBlue ]
        dataSet.drawValuesEnabled = false

        return dataSet
    }

    // 3. BarChartData 변환하기
    func makeBarChartData(year: Int) -> BarChartData {
        let dataEntry = makeBarChartDataEntry(year: year)
        let dataSet = makeBarChartDataSet(dataEntry)
        let data = BarChartData(dataSet: dataSet)

        return data
    }
}
