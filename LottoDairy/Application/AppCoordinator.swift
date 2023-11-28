//
//  AppCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/06/30.
//

import Foundation

final class AppCoordinator: BaseCoordinator {
    
    private let coordinatorFactory: CoordinatorFactory
    private let moduleFactory: LottoValidationModuleFactory
    private let router: Router
    
    init(router: Router,
         coordinatorFactory: CoordinatorFactory,
         moduleFactory: LottoValidationModuleFactory
    ) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
    }
    
    override func start() {
        runLottoValidationFlow()
//        runOnboardingFlow()
        runMainFlow()
    }

    private func runLottoValidationFlow() {
        let lottoValidationModule = moduleFactory.makeLottoValidationFlow()
        lottoValidationModule.updateLottosWithNoResult()
    }

    private func runOnboardingFlow() {
        let coordinator = coordinatorFactory.makeOnboardingCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.runMainFlow()
        }
        addDependency(coordinator)
        coordinator.start()
    }
    
    private func runMainFlow() {
        let (coordinator, module) = coordinatorFactory.makeTabbarCoordinator()
        addDependency(coordinator)
        router.setRootModule(module)
        coordinator.start()
    }
}
