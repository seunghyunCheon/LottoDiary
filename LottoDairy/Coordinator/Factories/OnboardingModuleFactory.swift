//
//  OnboardingModuleFactory.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/10.
//

protocol OnboardingModuleFactory {
    func makeOnboardingFlow() -> OnboardingFlowProtocol
}
