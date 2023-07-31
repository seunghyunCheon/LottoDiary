//
//  ModuleFactoryImp.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//
final class ModuleFactoryImp:
    HomeModuleFactory,
    OnboardingModuleFactory,
    GoalSettingModuleFactory,
    LottoQRModuleFactory {
    
    func makeHomeFlow() -> HomeFlowProtocol {
        return HomeViewController()
    }
    
    func makeOnboardingFlow() -> OnboardingFlowProtocol {
        let viewModel = OnboardingViewModel()
        
        return OnboardingViewController(viewModel: viewModel)
    }

    func makeLottoQRFlow() -> LottoQRFlowProtocol {
        return LottoQRViewController()
    
    func makeGoalSettingFlow() -> GoalSettingFlowProtocol {
        let goalSettingUseCase = DefaultGoalSettingUseCase()
        let viewModel = GoalSettingViewModel(goalSettingUseCase: goalSettingUseCase)
        
        return GoalSettingViewController(viewModel: viewModel)
    }
}

