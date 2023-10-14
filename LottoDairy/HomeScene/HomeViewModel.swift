//
//  HomeViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 10/13/23.
//

import Foundation
import Combine

final class HomeViewModel {

    private let goalSettingUseCase: GoalSettingUseCase
    private let chartLottoUseCase: ChartLottoUseCase

    struct Input {
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
    }

    struct Output {
        let nickNameTextField =  PassthroughSubject<String, Never>()
        var month = CurrentValueSubject<Int, Never>(0)
        var percent = CurrentValueSubject<Int, Never>(0)    // ??
        var informationComponents = CurrentValueSubject<[HomeInformationComponents], Never>([])
        var amounts = CurrentValueSubject<[Int], Never>([])
    }

    private var cancellables: Set<AnyCancellable> = []

    init(
        chartLottoUseCase: ChartLottoUseCase,
        goalSettingUseCase: GoalSettingUseCase
    ) {
        self.chartLottoUseCase = chartLottoUseCase
        self.goalSettingUseCase = goalSettingUseCase
    }

    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }

    private func configureInput(_ input: Input) {
        input.viewWillAppearEvent
            .sink {
                self.goalSettingUseCase.loadUserInfo()
            }
            .store(in: &cancellables)
    }

    private func configureOutput(from input: Input) -> Output {
        let output = Output()

        self.goalSettingUseCase.nickname
            .sink { name in
                output.nickNameTextField.send(name)
            }
            .store(in: &cancellables)

        return output
    }

    // 유저 닉네임 가져오기


    // 현재 월

    // 목표 금액 별 구매 금액 퍼센테이지 계산

    // 현재 월에 대한 목표, 구매, 당첨 금액 계산
}
