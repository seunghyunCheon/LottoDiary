//
//  CoreDataTotalAmountEntityPersistenceService.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/16.
//

import Foundation
import Combine

fileprivate enum CoreDataTotalAmountEntityPersistenceServiceError: LocalizedError {

    case failedToInitializeCoreDataContainer
    case failedToFetchAmount

    var errorDescription: String? {
        switch self {
        case .failedToInitializeCoreDataContainer:
            return "CoreDataContainer 초기화에 실패했습니다."
        case .failedToFetchAmount:
            return "GoalAmount 엔티티 불러오기에 실패했습니다."
        }
    }
}

final class CoreDataTotalAmountEntityPersistenceService: CoreDataTotalAmountEntityPersistenceServiceProtocol {

    private let coreDataPersistenceService: CoreDataPersistenceServiceProtocol

    init(coreDataPersistenceService: CoreDataPersistenceServiceProtocol) {
        self.coreDataPersistenceService = coreDataPersistenceService
    }

    func fetchTotalBuyAmount(month: Int) -> AnyPublisher<Double, Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataTotalAmountEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }

        return Future { promise in
            context.perform {

            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }



}
