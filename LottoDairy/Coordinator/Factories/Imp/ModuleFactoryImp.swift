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
    ChartModuleFactory,
    RandomNumberModuleFactory,
    AppSetupModuleFactory {

    func makeHomeFlow() -> HomeFlowProtocol {
        let coreDataService = CoreDataPersistenceService.shared
        let coreDataLottoPersistenceService = CoreDataLottoEntityPersistenceService(coreDataPersistenceService: coreDataService)
        let lottoRepository = DefaultLottoRepository(coreDataLottoEntityPersistenceService: coreDataLottoPersistenceService)
        let chartLottoUseCase = DefaultChartLottoUseCase(lottoRepository: lottoRepository)

        let userDefaultService = UserDefaultsPersistenceService()
        let userRepository = DefaultUserRepository(
            userDefaultPersistenceService: userDefaultService
        )
        let goalSettingUseCase = DefaultGoalSettingUseCase(userRepository: userRepository)

        let viewModel = HomeViewModel(
            amountUseCase: chartLottoUseCase,
            userUseCase: goalSettingUseCase
        )

        return HomeViewController(viewModel: viewModel)
    }
    
    func makeOnboardingFlow() -> OnboardingFlowProtocol {
        let viewModel = OnboardingViewModel()
        
        return OnboardingViewController(viewModel: viewModel)
    }

    func makeLottoQRFlow() -> LottoQRFlowProtocol {
        let coreDataService = CoreDataPersistenceService.shared
        let coreDataLottoPersistenceService = CoreDataLottoEntityPersistenceService(coreDataPersistenceService: coreDataService)
        let lottoRepository = DefaultLottoRepository(coreDataLottoEntityPersistenceService: coreDataLottoPersistenceService)
        let lottoResultValidationUseCase = DefaultLottoResultValidationUseCase(lottoRepository: lottoRepository)
        let viewModel = LottoQRViewModel(lottoResultValidationUseCase: lottoResultValidationUseCase)

        return LottoQRViewController(viewModel: viewModel)
    }
        
    func makeGoalSettingFlow(isEdit: Bool) -> GoalSettingFlowProtocol {
        let userDefaultService = UserDefaultsPersistenceService()
        let userRepository = DefaultUserRepository(
            userDefaultPersistenceService: userDefaultService
        )
        let goalSettingValidationUseCase = DefaultGoalSettingValidationUseCase()
        let goalSettingUseCase = DefaultGoalSettingUseCase(userRepository: userRepository)
        let viewModel = GoalSettingViewModel(
            isEdit: isEdit,
            goalSettingValidationUseCase: goalSettingValidationUseCase,
            goalSettingUseCase: goalSettingUseCase
        )
        
        return GoalSettingViewController(viewModel: viewModel)
    }

    func makeCalendarFlow() -> CalendarFlowProtocol {
        let coreDataService = CoreDataPersistenceService.shared
        let coreDataLottoPersistenceService = CoreDataLottoEntityPersistenceService(coreDataPersistenceService: coreDataService)
        let lottoRepository = DefaultLottoRepository(coreDataLottoEntityPersistenceService: coreDataLottoPersistenceService)
        let calendarUseCase = CalendarUseCase(lottoRepository: lottoRepository)
        let viewModel = CalendarViewModel(calendarUseCase: calendarUseCase)
        return CalendarViewController(viewModel: viewModel)
    }
    
    func makeAddLottoView() -> AddLottoViewProtocol {
        let coreDataService = CoreDataPersistenceService.shared
        let coreDataLottoPersistenceService = CoreDataLottoEntityPersistenceService(coreDataPersistenceService: coreDataService)
        let lottoRepository = DefaultLottoRepository(coreDataLottoEntityPersistenceService: coreDataLottoPersistenceService)
        let addLottoUseCase = DefaultAddLottoUseCase(lottoRepository: lottoRepository)
        let addLottoValidationUseCase = DefaultAddLottoValidationUseCase()
        let viewModel = AddLottoViewModel(
            addLottoUseCase: addLottoUseCase,
            addLottoValidationUseCase: addLottoValidationUseCase
        )
        
        return AddLottoViewController(viewModel: viewModel)
    }

    func makeChartFlow() -> ChartFlowProtocol {
        let coreDataService = CoreDataPersistenceService.shared
        let coreDataLottoPersistenceService = CoreDataLottoEntityPersistenceService(coreDataPersistenceService: coreDataService)
        let lottoRepository = DefaultLottoRepository(coreDataLottoEntityPersistenceService: coreDataLottoPersistenceService)
        let chartLottoUseCase = DefaultChartLottoUseCase(lottoRepository: lottoRepository)
        let userDefaultService = UserDefaultsPersistenceService()
        let userRepository = DefaultUserRepository(
            userDefaultPersistenceService: userDefaultService
        )
        let chartInformationUseCase = DefaultChartInformationUseCase(
            userRepository: userRepository,
            chartLottoUseCase: chartLottoUseCase
        )
        let chartUseCase = DefaultChartUseCase(chartLottoUseCase: chartLottoUseCase)
        let viewModel = ChartViewModel(
            chartUseCase: chartUseCase,
            chartInformationUseCase: chartInformationUseCase
        )
        return ChartViewController(viewModel: viewModel)
    }

    func makeLottoValidationFlow() -> LottoValidationFlowProtocol {
        let coreDataService = CoreDataPersistenceService.shared
        let coreDataLottoPersistenceService = CoreDataLottoEntityPersistenceService(coreDataPersistenceService: coreDataService)
        let lottoRepository = DefaultLottoRepository(coreDataLottoEntityPersistenceService: coreDataLottoPersistenceService)
        let lottoResultValidationUseCase = DefaultLottoResultValidationUseCase(lottoRepository: lottoRepository)
        return LottoValidationController(lottoResultValidationUseCase: lottoResultValidationUseCase)
    }

    func makeUserSetupFlow() -> UserSetupFlowProtocol {
        let userDefaultService = UserDefaultsPersistenceService()
        let userRepository = DefaultUserRepository(
            userDefaultPersistenceService: userDefaultService
        )
        return UserSetupController(userRepository: userRepository)
    }

    func makeRandomNumberFlow() -> RandomNumberFlowProtocol {
        return RandomNumberViewController()
    }
}
