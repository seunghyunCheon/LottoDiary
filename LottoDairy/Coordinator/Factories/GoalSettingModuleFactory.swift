//
//  GoalSettingModuleFactory.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/17.
//

protocol GoalSettingModuleFactory {
    func makeGoalSettingFlow(isEdit: Bool) -> GoalSettingFlowProtocol
}
