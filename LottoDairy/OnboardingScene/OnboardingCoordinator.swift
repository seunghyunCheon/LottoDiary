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
            self?.finishFlow?()
        }
        
        router.setRootModule(onboardingModule)
    }
}
