//
//  GoalSettingUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Combine

protocol GoalSettingUseCase {
    var nickname: String { get set }
    var goalAmount: Int? { get set }
    var nicknameValidationState: CurrentValueSubject<NickNameValidationState, Never> { get }
    var goalAmountValidationState: CurrentValueSubject<GoalAmountValidationState, Never> { get }
    func validateNickname(_ text: String)
    func validateAmount(_ text: String)
    func signUp() -> AnyPublisher<Bool, Error>
}
