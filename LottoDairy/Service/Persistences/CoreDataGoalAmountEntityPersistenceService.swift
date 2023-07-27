//
//  CoreDataGoalAmountEntityPersistenceService.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/27.
//

import Foundation
import Combine

fileprivate enum CoreDataGoalAmountEntityPersistenceServiceError: LocalizedError {
    
    case failedToInitializeCoreDataContainer
    case failedToCreateGoalAmount
    
    var errorDescription: String? {
        switch self {
        case .failedToInitializeCoreDataContainer:
            return "CoreDataContainer 초기화에 실패했습니다."
        case .failedToCreateGoalAmount:
            return "GoalAmount 엔티티 생성에 실패했습니다."
        }
    }
}

final class CoreDataGoalAmountEntityPersistenceService: CoreDataGoalAmountEntityPersistenceServiceProtocol {
    
    private let coreDataPersistenceService: CoreDataPersistenceServiceProtocol
    
    init(coreDataPersistenceService: CoreDataPersistenceServiceProtocol) {
        self.coreDataPersistenceService = coreDataPersistenceService
    }
    
    func saveGoalAmountEntity(_ goalAmount: Int16) -> AnyPublisher<Int16, Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataGoalAmountEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }
        
        return Future { promise in
            context.perform {
                let goalAmountEntity = GoalAmountEntity(context: context)
                goalAmountEntity.update(goalAmount)
                do {
                    try context.save()
                    promise(.success(goalAmount))
                } catch {
                    promise(.failure(CoreDataGoalAmountEntityPersistenceServiceError.failedToCreateGoalAmount))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
