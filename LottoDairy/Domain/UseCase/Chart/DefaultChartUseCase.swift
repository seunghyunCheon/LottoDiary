//
//  DefaultChartUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Foundation
import Combine

final class DefaultChartUseCase: ChartUseCase {

//    private let repository: CoreDataRepository

//    init(repository: CoreDataRepository) {
//        self.repository = repository
//    }

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
}
