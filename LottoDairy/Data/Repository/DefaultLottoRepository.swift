//
//  DefaultLottoRepository.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/16.
//

import Combine
import Foundation

final class DefaultLottoRepository: LottoRepository {
    
    private let coreDataLottoEntityPersistenceService: CoreDataLottoEntityPersistenceServiceProtocol
    
    init(
        coreDataLottoEntityPersistenceService: CoreDataLottoEntityPersistenceServiceProtocol
    ) {
        self.coreDataLottoEntityPersistenceService = coreDataLottoEntityPersistenceService
    }
    
    func fetchLottos(with startDate: Date, and endDate: Date) -> AnyPublisher<[Lotto], Error> {
        return coreDataLottoEntityPersistenceService.fetchLottoEntities(with: startDate, and: endDate)
            .flatMap { lottos -> AnyPublisher<[Lotto], Error> in
                return Just((lottos)).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    func fetchAllOfYear() -> AnyPublisher<[Int], Error> {
        return coreDataLottoEntityPersistenceService.fetchDistinctYear()
            .map { $0.sorted() }
            .eraseToAnyPublisher()
    }
    
    func saveLotto(_ lotto: Lotto) -> AnyPublisher<Lotto, Error> {
        return coreDataLottoEntityPersistenceService.saveLottoEntity(lotto)
    }
}
