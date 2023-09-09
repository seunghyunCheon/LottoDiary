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
    func makeYearAndMonthOfToday() -> [Int] {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        return [year, month]
    }

    // 특정 년도의 월에 대한 ChartInformationComponents 만드는 함수
    func makeChartInformationComponents(year: Int, month: Int) -> AnyPublisher<[ChartInformationComponents], Never> {

        return Future<[ChartInformationComponents], Never> { promise in
            // repository에서 특정 월에 대한 목표 금액 가져오기
            let goalAmount = (1...30000).randomElement()!

            // repository에서 특정 월에 대한 구매 금액 가져오기
            let buyAmount = (1000...50000).randomElement()!
            // repository에서 특정 월에 대한 당첨 금액 가져오기
            let winAmount = (1000...200000).randomElement()!

            let goalResult: Bool = goalAmount >= buyAmount
            let winResult: Bool = buyAmount <= winAmount
            let percent = Double(winAmount) / Double(buyAmount) * 100

            let chartInformationComponents = [
                ChartInformationComponents(
                    type: .goal,
                    amount: goalAmount,
                    result: (goalResult, nil)
                ),
                ChartInformationComponents(
                    type: .buy,
                    amount: buyAmount
                ),
                ChartInformationComponents(
                    type: .win,
                    amount: winAmount,
                    result: (winResult, Int(percent))
                )
            ]

            promise(.success(chartInformationComponents))
        }
        .eraseToAnyPublisher()
    }


    // MARK: ChartView 관련 함수

    // 데이터가 없는 월이라도 ChartComponents가 1월부터 12월까지 다 있어야 차트에서 일년치를 볼 수 있음.
    // 1년치의 ChartComponents를 만드는 함수
    private func makeChartComponents(year: Int) -> AnyPublisher<[ChartComponents], Never> {
        return Future<[ChartComponents], Never> { promise in
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

    // 1. BarChartDataEntry 생성
    private func makeBarChartDataEntry(year: Int) -> AnyPublisher<[BarChartDataEntry], Never> {
        return makeChartComponents(year: year)
            .map { chartComponents in
                chartComponents.map { chartComponent in
                    BarChartDataEntry(x: Double(chartComponent.month), y: chartComponent.account)
                }
            }
            .eraseToAnyPublisher()
    }

    // 2. BarChartSet 생성
    private func makeBarChartDataSet(year: Int) -> AnyPublisher<BarChartDataSet, Never> {
        return makeBarChartDataEntry(year: year)
            .map { barChartDataEntry in
                let dataSet = BarChartDataSet(entries: barChartDataEntry)
                dataSet.colors = [ .designSystem(.mainBlue) ?? .systemBlue ]
                dataSet.drawValuesEnabled = false
                return dataSet
            }
            .eraseToAnyPublisher()
    }

    // 3. BarChartData 변환하기
    func makeBarChartData(year: Int) -> AnyPublisher<BarChartData, Never> {
        return makeBarChartDataSet(year: year)
            .map { barChartDataSet in
                BarChartData(dataSet: barChartDataSet)
            }
            .eraseToAnyPublisher()
    }
}
