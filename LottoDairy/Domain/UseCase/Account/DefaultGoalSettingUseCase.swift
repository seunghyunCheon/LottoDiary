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
    
    var nickname: String = ""
    var goalAmount: Int?
    var selectedNotificationCycle: NotificationCycle?
    
    private let userRepository: UserRepository
    
    init(userRepository: UserRepository) {
        self.userRepository = userRepository
    }
    
    func validateNickname(_ text: String) {
        self.nickname = text
        self.updateNicknameValidationState(of: text)
    }
    
    func validateAmount(_ text: String) {
        self.goalAmount = text.convertDecimalToInt()
        self.updateGoalAmountValidationState()
    }

    func signUp() -> AnyPublisher<Int, Error> {
        guard let notificationCycle = selectedNotificationCycle?.rawValue,
              let goalAmount else {
            return Fail(error: GoalSettingUseCaseError.signUpError).eraseToAnyPublisher()
        }
        
        return userRepository.saveUserInfo(nickname: self.nickname, notificationCycle: notificationCycle, goalAmount: goalAmount)
    }
    
    func loadNotificationCycle() {
        self.notificationCycleList.send(NotificationCycle.allCases)
    }
    
    func setNotificationCycle(_ text: String) {
        self.selectedNotificationCycle = NotificationCycle(rawValue: text)
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
        guard let goalAmount = goalAmount else {
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
