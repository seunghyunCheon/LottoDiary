//
//  GoalSettingUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Combine

protocol GoalSettingUseCase {
    var nicknameValidationState: CurrentValueSubject<NickNameValidationState, Never> { get }
    var goalAmountValidationState: CurrentValueSubject<GoalAmountValidationState, Never> { get }
    var notificationFieldEnabled: CurrentValueSubject<Bool, Never> { get }
    var notificationCycleList: CurrentValueSubject<[NotificationCycle], Never> { get }
    var okButtonEnabled: AnyPublisher<Bool, Never> { get }
    var nickname: CurrentValueSubject<String, Never> { get set }
    var goalAmount: CurrentValueSubject<Int?, Never> { get set }
    var selectedNotificationCycle: CurrentValueSubject<NotificationCycle?, Never> { get }
    
    func validateNickname(_ text: String)
    func validateAmount(_ text: String)
    func loadNotificationCycle()
    func loadUserInfo()
    func setNotificationCycle(_ text: String)
    func signUp() -> AnyPublisher<Int, Error>
}
