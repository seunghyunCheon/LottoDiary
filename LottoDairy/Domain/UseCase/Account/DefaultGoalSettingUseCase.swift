//
//  DefaultGoalSettingUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Foundation
import Combine

final class DefaultGoalSettingUseCase: GoalSettingUseCase {
    
    var nickname: String = ""
    var nicknameValidationState = CurrentValueSubject<NickNameValidationState, Never>(NickNameValidationState.empty)
    var goalAmount: Int?
    var goalAmountValidationState = CurrentValueSubject<GoalAmountValidationState, Never>(GoalAmountValidationState.lowerboundViolated)
    
    func validateNickname(_ text: String) {
        self.nickname = text
        self.updateNicknameValidationState(of: text)
    }
    
    func validateAmount(_ text: String) {
        // 1. 뷰모델에서 ,가 붙은 텍스트를 useCase에 보내고 ,가 붙은 텍스트를 숫자로 바꿔 저장.
        // 2. 뷰모델에서 ,가 붙은 텍스트를 useCase에 보내고 ,가 붙은 숫자를 반환받아 Output으로 전달.
        self.goalAmount = text.convertDecimalToInt()
        self.updateGoalAmountValidationState()
    }

    func signUp() -> AnyPublisher<Bool, Error> {
        Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
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
            return
        }
        
        guard goalAmount <= 1_000 else {
            self.goalAmountValidationState.send(.lowerboundViolated)
            return
        }
        
        guard goalAmount >= 100_000_000_000 else {
            self.goalAmountValidationState.send(.upperboundViolated)
            return
        }
        
        self.goalAmountValidationState.send(.success)
     }
}
