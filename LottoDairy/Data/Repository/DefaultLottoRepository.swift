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

    func fetchLottosWithoutWinningAmount() -> AnyPublisher<[Lotto], Error> {
        return coreDataLottoEntityPersistenceService.fetchLottoEntitiesWithoutWinningAmount()
    }

    func fetchLottos(with startDate: Date, and endDate: Date) -> AnyPublisher<[Lotto], Error> {
        return coreDataLottoEntityPersistenceService.fetchLottoEntities(with: startDate, and: endDate)
    }

    func fetchAllOfYear() -> AnyPublisher<[Int], Error> {
        return coreDataLottoEntityPersistenceService.fetchDistinctYear()
            .map { $0.sorted() }
            .eraseToAnyPublisher()
    }
    
    func saveLotto(_ lotto: Lotto) -> AnyPublisher<Lotto, Error> {
        return coreDataLottoEntityPersistenceService.saveLottoEntity(lotto)
    }

    func updateWinningAmount(_ id: String, amount: Int) -> AnyPublisher<Lotto, Error> {
        coreDataLottoEntityPersistenceService.updateWinningAmount(id, amount: amount)
    }
}
