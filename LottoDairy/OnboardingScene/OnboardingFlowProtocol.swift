//
//  OnboardingFlowProtocol.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/10.
//

protocol OnboardingFlowProtocol: Presentable {
    var onSetting: (() -> Void)? { get set }
}
