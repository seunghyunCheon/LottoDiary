//
//  DefaultUserRepository.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/22.
//

import Foundation
import Combine

final class DefaultUserRepository: UserRepository {
    
    private let userDefaultsPersistenceService: UserDefaultsPersistenceServiceProtocol
    private let coreDataGoalAmountEntityPersistenceService: CoreDataGoalAmountEntityPersistenceServiceProtocol
    
    init(
        userDefaultPersistenceService: UserDefaultsPersistenceServiceProtocol,
        coreDataGoalAmountEntityPersistenceService: CoreDataGoalAmountEntityPersistenceServiceProtocol
    ) {
        self.userDefaultsPersistenceService = userDefaultPersistenceService
        self.coreDataGoalAmountEntityPersistenceService = coreDataGoalAmountEntityPersistenceService
    }
    
    func saveUserInfo(nickname: String, notificationCycle: String, goalAmount: Int) -> AnyPublisher<Int, Error> {
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.nickname, value: nickname)
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.notificationCycle, value: notificationCycle)
        
        return coreDataGoalAmountEntityPersistenceService.saveGoalAmountEntity(goalAmount)
    }
}
