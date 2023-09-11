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
    case failedToFetchGoalAmount
    
    var errorDescription: String? {
        switch self {
        case .failedToInitializeCoreDataContainer:
            return "CoreDataContainer 초기화에 실패했습니다."
        case .failedToCreateGoalAmount:
            return "GoalAmount 엔티티 생성에 실패했습니다."
        case .failedToFetchGoalAmount:
            return "GoalAmount 엔티티 불러오기에 실패했습니다."
        }
    }
}

final class CoreDataGoalAmountEntityPersistenceService: CoreDataGoalAmountEntityPersistenceServiceProtocol {
    
    private let coreDataPersistenceService: CoreDataPersistenceServiceProtocol
    
    init(coreDataPersistenceService: CoreDataPersistenceServiceProtocol) {
        self.coreDataPersistenceService = coreDataPersistenceService
    }
    
    func fetchGoalAmount() -> AnyPublisher<Int, Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataGoalAmountEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }
        
        return Future { promise in
            context.perform {
                let fetchRequest = GoalAmountEntity.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    promise(.success(fetchResult[0].goalAmount))
                } catch {
                    promise(.failure(CoreDataGoalAmountEntityPersistenceServiceError.failedToFetchGoalAmount))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func saveGoalAmountEntity(_ goalAmount: Int) -> AnyPublisher<Void, Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataGoalAmountEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }
        
        return Future { promise in
            context.perform {
                do {
                    let fetchRequest = GoalAmountEntity.fetchRequest()
                    let fetchResult = try context.fetch(fetchRequest)
                    
                    if fetchResult.isEmpty {
                        let goalAmountEntity = GoalAmountEntity(context: context)
                        goalAmountEntity.update(goalAmount)
                        try context.save()
                        promise(.success(()))
                    }
                    
                    fetchResult[0].update(goalAmount)
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(CoreDataGoalAmountEntityPersistenceServiceError.failedToCreateGoalAmount))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
