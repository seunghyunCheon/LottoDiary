//
//  DefaultGoalSettingValidationUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/31.
//

import Combine

final class DefaultGoalSettingValidationUseCase: GoalSettingValidationUseCase {
    
    var nicknameValidationState = CurrentValueSubject<NickNameValidationState, Never>(NickNameValidationState.empty)
    var goalAmountValidationState = CurrentValueSubject<GoalAmountValidationState, Never>(GoalAmountValidationState.empty)
    var notificationFieldEnabled = CurrentValueSubject<Bool, Never>(false)
    
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
    
    func activateAllComponent() {
        self.nicknameValidationState.send(.success)
        self.goalAmountValidationState.send(.success)
        self.notificationFieldEnabled.send(true)
    }
    
    func validateNickname(_ text: String) {
        self.updateNicknameValidationState(of: text)
    }
    
    func activateNotificationCycle() {
        self.notificationFieldEnabled.send(true)
    }
    
    func validateAmount(_ text: String) {
        self.updateGoalAmountValidationState(of: text.convertDecimalToInt())
    }
    
    // MARK: - Private Methods
    
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
    
    private func updateGoalAmountValidationState(of goalAmount: Int?) {
        guard let goalAmount else {
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
