//
//  DefaultUserRepository.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/22.
//

import Foundation
import Combine

fileprivate enum UserRepositoryError: LocalizedError {
    case failedToFetchDataFromUserDefaults
    
    var errorDescription: String? {
        switch self {
        case .failedToFetchDataFromUserDefaults:
            return "userDefaults로부터 데이터를 가져오는데 실패했습니다."
        }
    }
}

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
    
    func fetchUserData() -> AnyPublisher<(String, String, Int), Error> {
        guard let userNickname: String = userDefaultsPersistenceService.get(key: UserDefaults.Keys.nickname),
              let userCycle: String = userDefaultsPersistenceService.get(key: UserDefaults.Keys.notificationCycle) else {
            return Fail(error: UserRepositoryError.failedToFetchDataFromUserDefaults).eraseToAnyPublisher()
        }
        
        return coreDataGoalAmountEntityPersistenceService.fetchGoalAmount()
            .flatMap { goalAmount -> AnyPublisher<(String, String, Int), Error> in
                return Just((userNickname, userCycle, goalAmount)).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func saveUserInfo(nickname: String, notificationCycle: String, goalAmount: Int) -> AnyPublisher<Int, Error> {
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.nickname, value: nickname)
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.notificationCycle, value: notificationCycle)
        
        return coreDataGoalAmountEntityPersistenceService.saveGoalAmountEntity(goalAmount)
    }
}
