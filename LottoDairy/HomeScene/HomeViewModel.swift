//
//  HomeViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 10/13/23.
//

import Foundation

final class HomeViewModel {

    private let goalSettingUseCase: GoalSettingUseCase
    private let chartLottoUseCase: ChartLottoUseCase

    init(
        chartLottoUseCase: ChartLottoUseCase,
        goalSettingUseCase: GoalSettingUseCase
    ) {
        self.chartLottoUseCase = chartLottoUseCase
        self.goalSettingUseCase = goalSettingUseCase
    }

    // 유저 닉네임 가져오기

    // 현재 월

    // 목표 금액 별 구매 금액 퍼센테이지 계산

    // 현재 월에 대한 목표, 구매, 당첨 금액 계산
}
