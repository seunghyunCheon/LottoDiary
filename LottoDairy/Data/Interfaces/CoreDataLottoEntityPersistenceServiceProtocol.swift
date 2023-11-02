//
//  CoreDataLottoEntityPersistenceServiceProtocol.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/16.
//

import Foundation
import Combine

protocol CoreDataLottoEntityPersistenceServiceProtocol {
    func saveLottoEntity(_ lotto: Lotto) -> AnyPublisher<Lotto, Error>
    func fetchLottoEntities(with startDate: Date, and endDate: Date) -> AnyPublisher<[Lotto], Error>
    func fetchLottoEntitiesWithoutWinningAmount() -> AnyPublisher<[Lotto], Error>
    func fetchDistinctYear() -> AnyPublisher<Set<Int>, Error>
}
