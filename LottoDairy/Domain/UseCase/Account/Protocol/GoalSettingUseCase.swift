//
//  GoalSettingUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Combine

protocol GoalSettingUseCase {
    var nickname: String { get set }
    var nicknameValidationState: CurrentValueSubject<NickNameValidationState, Never> { get }
    func validate(text: String)
    func signUp() -> AnyPublisher<Bool, Error>
}
