//
//  DefaultGoalSettingUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Foundation
import Combine

fileprivate enum GoalSettingUseCaseError: LocalizedError {
    
    case signUpError
    
    var errorDescription: String? {
        switch self {
        case .signUpError:
            return "회원가입에 실패했습니다."
        }
    }
}

final class DefaultGoalSettingUseCase: GoalSettingUseCase {
    
    var notificationCycleList = CurrentValueSubject<[NotificationCycle], Never>([])
    var nickname = CurrentValueSubject<String, Never>("")
    var goalAmount = CurrentValueSubject<Int?, Never>(nil)
    var selectedNotificationCycle = CurrentValueSubject<NotificationCycle?, Never>(nil)
    
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func setNickname(_ text: String) {
        self.nickname.value = text
    }
    
    func setGoalAmount(_ text: String) {
        self.goalAmount.value = text.convertDecimalToInt()
    }

    func signUp() -> AnyPublisher<Void, Error> {
        guard let notificationCycle = selectedNotificationCycle.value?.rawValue,
              let goalAmount = goalAmount.value else {
            return Fail(error: GoalSettingUseCaseError.signUpError)
                .eraseToAnyPublisher()
        }

        return userRepository.saveUserInfo(nickname: self.nickname.value, notificationCycle: notificationCycle, goalAmount: goalAmount)
    }
    
    func loadNotificationCycle() {
        self.notificationCycleList.send(NotificationCycle.allCases)
    }
    
    func loadUserInfo() {
        userRepository.fetchUserData()
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { (nickname, cycle, goalAmount) in
                self.nickname.value = nickname
                self.selectedNotificationCycle.value = NotificationCycle(rawValue: cycle)
                self.goalAmount.value = goalAmount
            }
            .store(in: &cancellables)
    }
    
    func setNotificationCycle(_ text: String) {
        self.selectedNotificationCycle.value = NotificationCycle(rawValue: text)
    }
}
