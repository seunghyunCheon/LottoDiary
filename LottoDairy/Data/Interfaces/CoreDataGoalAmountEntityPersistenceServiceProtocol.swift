//
//  CoreDataGoalAmountEntityPersistenceServiceProtocol.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/27.
//

import Foundation
import Combine

protocol CoreDataGoalAmountEntityPersistenceServiceProtocol {
    func saveGoalAmountEntity(_ goalAmount: Int16) -> AnyPublisher<Int16, Error>
}
