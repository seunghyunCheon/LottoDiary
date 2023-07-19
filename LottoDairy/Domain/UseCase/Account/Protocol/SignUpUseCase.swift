//
//  SignUpUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Combine

protocol SignUpUseCase {
    var nickname: String { get set }
    var nicknameValidationState: CurrentValueSubject<SignUpValidationState, Never> { get }
    func validate(text: String)
    func signUp() -> AnyPublisher<Bool, Error>
}
