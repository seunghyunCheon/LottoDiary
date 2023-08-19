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
    }
        
    func makeGoalSettingFlow() -> GoalSettingFlowProtocol {
        let userDefaultService = UserDefaultsPersistenceService()
        let coreDataService = CoreDataPersistenceService.shared
        let coreDataGoalAmountPersistenceService = CoreDataGoalAmountEntityPersistenceService(coreDataPersistenceService: coreDataService)
        let userRepository = DefaultUserRepository(
            userDefaultPersistenceService: userDefaultService,
            coreDataGoalAmountEntityPersistenceService: coreDataGoalAmountPersistenceService
        )
        let goalSettingValidationUseCase = DefaultGoalSettingValidationUseCase()
        let goalSettingUseCase = DefaultGoalSettingUseCase(userRepository: userRepository)
        let viewModel = GoalSettingViewModel(
            goalSettingValidationUseCase: goalSettingValidationUseCase,
            goalSettingUseCase: goalSettingUseCase
        )
        
        return GoalSettingViewController(viewModel: viewModel)
    }
}
