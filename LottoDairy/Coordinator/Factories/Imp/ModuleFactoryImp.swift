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
    LottoQRModuleFactory,
    CalendarModuleFactory {
    
    func makeHomeFlow() -> HomeFlowProtocol {
        return HomeViewController()
    }
    
    func makeOnboardingFlow() -> OnboardingFlowProtocol {
        let viewModel = OnboardingViewModel()
        
        return OnboardingViewController(viewModel: viewModel)
    }

    func makeLottoQRFlow() -> LottoQRFlowProtocol {
        return LottoQRViewController()
    }
        
    func makeGoalSettingFlow() -> GoalSettingFlowProtocol {
        let goalSettingUseCase = DefaultGoalSettingUseCase()
        let viewModel = GoalSettingViewModel(goalSettingUseCase: goalSettingUseCase)
        
        return GoalSettingViewController(viewModel: viewModel)
    }

    func makeCalendarFlow() -> CalendarFlowProtocol {
        let calendarUseCase = CalendarUseCase()
        let viewModel = CalendarViewModel(calendarUseCase: calendarUseCase)
        return CalendarViewController(viewModel: viewModel)
    }
}
