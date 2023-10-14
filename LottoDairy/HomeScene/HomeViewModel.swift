//
//  HomeViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 10/13/23.
//

import Foundation
import Combine

final class HomeViewModel {

    private let userUseCase: GoalSettingUseCase
    private let amountUseCase: ChartLottoUseCase

    struct Input {
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
    }

    struct Output {
        let nickNameTextField =  PassthroughSubject<String, Never>()
        var month = CurrentValueSubject<Int, Never>(0)
        var percent = CurrentValueSubject<Int, Never>(0)    // ??
        var goalAmount = CurrentValueSubject<Int?, Never>(nil)
        var buyAmount = CurrentValueSubject<Int, Never>(0)
        var winAmount = CurrentValueSubject<Int, Never>(0)
    }

    private var cancellables: Set<AnyCancellable> = []

    init(
        amountUseCase: ChartLottoUseCase,
        userUseCase: GoalSettingUseCase
    ) {
        self.amountUseCase = amountUseCase
        self.userUseCase = userUseCase
    }

    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }

    private func configureInput(_ input: Input) {
        input.viewWillAppearEvent
            .sink {
                self.userUseCase.loadUserInfo()
            }
            .store(in: &cancellables)
    }

    private func configureOutput(from input: Input) -> Output {
        let output = Output()

        self.userUseCase.nickname
            .sink { name in
                output.nickNameTextField.send(name)
            }
            .store(in: &cancellables)

        self.userUseCase.goalAmount
            .sink { goal in
                output.goalAmount.send(goal)
            }
            .store(in: &cancellables)

        return output
    }

    // 현재 월

    // 목표 금액 별 구매 금액 퍼센테이지 계산

    // 현재 월에 대한 목표 금액

    // 구매, 당첨 금액 계산
}
