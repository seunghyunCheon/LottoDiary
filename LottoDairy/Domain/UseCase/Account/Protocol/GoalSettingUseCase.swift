//
//  GoalSettingUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Combine

protocol GoalSettingUseCase {
    var notificationCycleList: CurrentValueSubject<[NotificationCycle], Never> { get }
    var nickname: CurrentValueSubject<String, Never> { get set }
    var goalAmount: CurrentValueSubject<Int?, Never> { get set }
    var selectedNotificationCycle: CurrentValueSubject<NotificationCycle?, Never> { get }
    func setNickname(_ text: String)
    func setGoalAmount(_ text: String)
    func loadNotificationCycle()
    func loadUserInfo()
    func setNotificationCycle(_ text: String)
    func signUp() -> AnyPublisher<Int, Error>
}
