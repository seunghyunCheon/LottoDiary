//
//  GoalSettingFlowProtocol.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/17.
//

protocol GoalSettingFlowProtocol: Presentable {
    var onMain: (() -> Void)? { get set }
}
