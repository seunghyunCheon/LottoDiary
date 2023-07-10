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
    
    private let factory: OnboardingModuleFactory
    private let router: Router
    
    init(router: Router, factory: OnboardingModuleFactory) {
        self.factory = factory
        self.router = router
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
