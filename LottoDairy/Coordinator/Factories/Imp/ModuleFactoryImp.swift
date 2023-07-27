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
        let userDefaultService = UserDefaultsPersistenceService.shared
        let coreDataService = CoreDataPersistenceService.shared
        let coreDataGoalAmountPersistenceService = CoreDataGoalAmountEntityPersistenceService(coreDataPersistenceService: coreDataService)
        let userRepository = DefaultUserRepository(
            userDefaultPersistenceService: userDefaultService,
            coreDataGoalAmountEntityPersistenceService: coreDataGoalAmountPersistenceService
        )
        let goalSettingUseCase = DefaultGoalSettingUseCase(userRepository: userRepository)
        let viewModel = GoalSettingViewModel(goalSettingUseCase: goalSettingUseCase)
        
        return GoalSettingViewController(viewModel: viewModel)
    }
}

