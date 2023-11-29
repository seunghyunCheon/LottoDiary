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
    case failedToFetchGoalAmount

    var errorDescription: String? {
        switch self {
        case .failedToFetchDataFromUserDefaults:
            return "userDefaults로부터 데이터를 가져오는데 실패했습니다."
        case .failedToFetchGoalAmount:
            return "목표 금액을 UserDefaults로부터 가져오는데 실패했습니다."
        }
    }
}

final class DefaultUserRepository: UserRepository {
    
    private let userDefaultsPersistenceService: UserDefaultsPersistenceServiceProtocol
    
    init(
        userDefaultPersistenceService: UserDefaultsPersistenceServiceProtocol
    ) {
        self.userDefaultsPersistenceService = userDefaultPersistenceService
    }

    func fetchGoalAmount() -> AnyPublisher<Int, Error> {
        guard let goalAmount: Int = userDefaultsPersistenceService.get(key: UserDefaults.Keys.goalAmount) else {
            return Fail(error: UserRepositoryError.failedToFetchGoalAmount)
                .eraseToAnyPublisher()
        }

        return Just(goalAmount).setFailureType(to: Error.self).eraseToAnyPublisher()
    }

    func fetchUserData() -> AnyPublisher<(String, String, Int), Error> {
        guard let userNickname: String = userDefaultsPersistenceService.get(key: UserDefaults.Keys.nickname),
              let userCycle: String = userDefaultsPersistenceService.get(key: UserDefaults.Keys.notificationCycle),
              let goalAmount: Int = userDefaultsPersistenceService.get(key: UserDefaults.Keys.goalAmount)
        else {
            return Fail(error: UserRepositoryError.failedToFetchDataFromUserDefaults).eraseToAnyPublisher()
        }
        
        return  Just((userNickname, userCycle, goalAmount)).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    func saveUserInfo(nickname: String, notificationCycle: String, goalAmount: Int) -> AnyPublisher<Void, Error> {
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.nickname, value: nickname)
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.notificationCycle, value: notificationCycle)
        self.userDefaultsPersistenceService.set(key: UserDefaults.Keys.goalAmount, value: goalAmount)

        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
