//
//  DefaultUserRepository.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/22.
//

import Foundation

final class DefaultUserRepository: UserRepository {
    
    private let userDefaultsPersistenceService: UserDefaultsPersistenceServiceProtocol
    
    init(userDefaultPersistenceService: UserDefaultsPersistenceServiceProtocol) {
        self.userDefaultsPersistenceService = userDefaultPersistenceService
    }
    
    func saveUserInfo(nickname: String, notificationCycle: String) {
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.nickname, value: nickname)
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.notificationCycle, value: notificationCycle)
    }
}
