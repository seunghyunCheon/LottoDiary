//
//  ModuleFactoryImp.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

final class ModuleFactoryImp:
    HomeModuleFactory,
    OnboardingModuleFactory,
    GoalSettingModuleFactory {
    
    func makeHomeFlow() -> HomeFlowProtocol {
        return HomeViewController()
    }
    
    func makeOnboardingFlow() -> OnboardingFlowProtocol {
        let viewModel = OnboardingViewModel()
        
        return OnboardingViewController(viewModel: viewModel)
    }
    
    func makeGoalSettingFlow() -> GoalSettingFlowProtocol {
        let goalSettingUseCase = DefaultGoalSettingUseCase()
        let viewModel = GoalSettingViewModel(goalSettingUseCase: goalSettingUseCase)
        
        return GoalSettingViewController(viewModel: viewModel)
    }
}

