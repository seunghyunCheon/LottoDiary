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
    
    var nicknameValidationState = CurrentValueSubject<NickNameValidationState, Never>(NickNameValidationState.empty)
    var goalAmountValidationState = CurrentValueSubject<GoalAmountValidationState, Never>(GoalAmountValidationState.empty)
    var notificationFieldEnabled = CurrentValueSubject<Bool, Never>(false)
    var notificationCycleList = CurrentValueSubject<[NotificationCycle], Never>([])
    var okButtonEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(
            nicknameValidationState,
            goalAmountValidationState,
            notificationFieldEnabled
        )
        .map { (nickNameValidation, goalAmountValidation, cycleValidation) in
            return nickNameValidation == .success && goalAmountValidation == .success && cycleValidation
        }
        .eraseToAnyPublisher()
    }
    
    var nickname = CurrentValueSubject<String, Never>("")
    var goalAmount = CurrentValueSubject<Int?, Never>(nil)
    var selectedNotificationCycle = CurrentValueSubject<NotificationCycle?, Never>(nil)
    
    private let userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func validateNickname(_ text: String) {
        self.nickname.value = text
        self.updateNicknameValidationState(of: text)
    }
    
    func validateAmount(_ text: String) {
        self.goalAmount.value = text.convertDecimalToInt()
        self.updateGoalAmountValidationState()
    }

    func signUp() -> AnyPublisher<Int, Error> {
        guard let notificationCycle = selectedNotificationCycle.value?.rawValue,
              let goalAmount = goalAmount.value else {
            return Fail(error: GoalSettingUseCaseError.signUpError).eraseToAnyPublisher()
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
                self.nicknameValidationState.send(.success)
                self.goalAmountValidationState.send(.success)
                self.notificationFieldEnabled.send(true)
            }
            .store(in: &cancellables)
        
    }
    
    func setNotificationCycle(_ text: String) {
        self.selectedNotificationCycle.value = NotificationCycle(rawValue: text)
        self.notificationFieldEnabled.send((true))
    }
    
    private func updateNicknameValidationState(of nicknameText: String) {
        guard !nicknameText.isEmpty else {
            self.nicknameValidationState.send(.empty)
            return
        }
        
        guard nicknameText.count >= 3 else {
            self.nicknameValidationState.send(.lowerboundViolated)
            return
        }
        
        guard nicknameText.count <= 10 else {
            self.nicknameValidationState.send(.upperboundViolated)
            return
        }
        
        guard nicknameText.range(of: "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]+$", options: .regularExpression) != nil else {
            self.nicknameValidationState.send(.invalidLetterIncluded)
            return
        }
        
        self.nicknameValidationState.send(.success)
    }
    
    private func updateGoalAmountValidationState() {
        guard let goalAmount = goalAmount.value else {
            self.goalAmountValidationState.send(.empty)
            return
        }
        
        guard goalAmount >= 1_000 else {
            self.goalAmountValidationState.send(.lowerboundViolated)
            return
        }
        
        guard goalAmount <= 100_000_000_000 else {
            self.goalAmountValidationState.send(.upperboundViolated)
            return
        }
        
        self.goalAmountValidationState.send(.success)
     }
}
