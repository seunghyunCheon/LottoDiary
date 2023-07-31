//
//  OnboardingCoordinator.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/10.
//

protocol OnboardingCoordinatorFinishable: AnyObject {
    var finishFlow: (() -> Void)? { get set }
}

final class OnboardingCoordinator: BaseCoordinator, OnboardingCoordinatorFinishable {
    
    var finishFlow: (() -> Void)?
    
    private let router: Router
    private let coordinatorFactory: CoordinatorFactory
    private let factory: OnboardingModuleFactory
    
    init(router: Router, coordinatorFactory: CoordinatorFactory, factory: OnboardingModuleFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.factory = factory
    }
    
    override func start() {
        showOnboarding()
    }
    
    func showOnboarding() {
        var onboardingModule = factory.makeOnboardingFlow()
        
        onboardingModule.onSetting = { [weak self] in
            self?.runGoalSettingFlow()
        }
        
        router.setRootModule(onboardingModule)
    }
    
    func runGoalSettingFlow() {
        let coordinator = coordinatorFactory.makeGoalSettingCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.finishFlow?()
        }
        addDependency(coordinator)
        coordinator.start()
    }
}
