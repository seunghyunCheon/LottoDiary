//
//  DefaultSignUpUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Foundation
import Combine

final class DefaultSignUpUseCase: SignUpUseCase {
    
    var nickname: String = ""
    var nicknameValidationState = CurrentValueSubject<SignUpValidationState, Never>(SignUpValidationState.empty)
    
    func validate(text: String) {
        self.nickname = text
        self.updateValidationState(of: text)
    }
    
    func signUp() -> AnyPublisher<Bool, Error> {
        Just(true).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    
    private func updateValidationState(of nicknameText: String) {
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
        
        guard nicknameText.range(of: "[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]", options: .regularExpression) == nil else {
            self.nicknameValidationState.send(.invalidLetterIncluded)
            return
        }
        
        self.nicknameValidationState.send(.success)
    }
}
