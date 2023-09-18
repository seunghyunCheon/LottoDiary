//
//  CoreDataLottoEntityPersistenceService.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/16.
//

import Foundation
import Combine

fileprivate enum CoreDataLottoEntityPersistenceServiceError: LocalizedError {
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

final class CoreDataLottoEntityPersistenceService: CoreDataLottoEntityPersistenceServiceProtocol {
    
    private let coreDataPersistenceService: CoreDataPersistenceServiceProtocol

    init(coreDataPersistenceService: CoreDataPersistenceServiceProtocol) {
        self.coreDataPersistenceService = coreDataPersistenceService
    }

    func fetchLottoEntities(with startDate: Date, and endDate: Date) -> AnyPublisher<[Lotto], Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataLottoEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }

        return Future { promise in
            context.perform {
                let fetchRequest = LottoEntity.fetchRequest()
                let predicate = NSPredicate(format: "date >= %@ && date <= %@", startDate as CVarArg, endDate as CVarArg)
                fetchRequest.predicate = predicate
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    promise(.success(fetchResult.map { $0.convertToDomain() }))
                } catch {
                    promise(.failure(CoreDataLottoEntityPersistenceServiceError.failedToFetchGoalAmount))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }

    func saveLottoEntity(_ lotto: Lotto) -> AnyPublisher<Lotto, Error> {
        guard let context = coreDataPersistenceService.backgroundContext else {
            return Fail(error: CoreDataLottoEntityPersistenceServiceError.failedToInitializeCoreDataContainer).eraseToAnyPublisher()
        }
        
        return Future { promise in
            context.perform {
                do {
                    let lottoEntity = LottoEntity(context: context)
                    lottoEntity.update(lotto: lotto)
                    try context.save()
                    promise(.success(lottoEntity.convertToDomain()))
            
                } catch {
                    promise(.failure(CoreDataLottoEntityPersistenceServiceError.failedToCreateGoalAmount))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
