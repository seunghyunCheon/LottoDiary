//
//  AppCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/06/30.
//

import Foundation

final class AppCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactory
    private let router: Router
    
    init(router: Router, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        runOnboardingFlow()
    }
    
    private func runOnboardingFlow() {
        let coordinator = coordinatorFactory.makeOnboardingCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.runMyInformationFlow()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMyInformationFlow() {
        print("info tapped")
    }
    
    private func runMainFlow() {
        let (coordinator, module) = coordinatorFactory.makeTabbarCoordinator()
        addDependency(coordinator)
        router.setRootModule(module)
        coordinator.start()
    }
}
