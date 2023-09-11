//
//  GoalSettingValidationUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/31.
//

import Combine

protocol GoalSettingValidationUseCase {
    var nicknameValidationState: CurrentValueSubject<NickNameValidationState, Never> { get }
    var goalAmountValidationState: CurrentValueSubject<GoalAmountValidationState, Never> { get }
    var notificationFieldEnabled: CurrentValueSubject<Bool, Never> { get }
    var okButtonEnabled: AnyPublisher<Bool, Never> { get }
    func activateAllComponent()
    func validateNickname(_ text: String)
    func validateAmount(_ text: String)
    func activateNotificationCycle()
}
