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
    CalendarModuleFactory,
    ChartModuleFactory {
    
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

    func makeCalendarFlow() -> CalendarFlowProtocol {
        let calendarUseCase = CalendarUseCase()
        let viewModel = CalendarViewModel(calendarUseCase: calendarUseCase)
        return CalendarViewController(viewModel: viewModel)
    }
    
    func makeAddLottoView() -> AddLottoViewProtocol {
        
        return AddLottoViewController()
    }

    func makeChartFlow() -> ChartFlowProtocol {
        let chartInformationUseCase = DefaultChartInformationUseCase()
        let chartUseCase = DefaultChartUseCase()
        let viewModel = ChartViewModel(chartUseCase: chartUseCase, chartInformationUseCase: chartInformationUseCase)
        return ChartViewController(viewModel: viewModel)
    }
}
