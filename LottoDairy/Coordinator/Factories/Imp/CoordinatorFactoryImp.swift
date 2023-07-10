//
//  CoordinatorFactoryImp.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit

final class CoordinatorFactoryImp: CoordinatorFactory {
    
    func makeOnboardingCoordinator(router: Router) -> Coordinator & OnboardingCoordinatorFinishable {
        let coordinator = OnboardingCoordinator(router: router, factory: ModuleFactoryImp())
        
        return coordinator
    }
    
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?) {
        let controller = TabBarController()
        let coordinator = TabBarCoordinator(tabBarFlow: controller, coordinatorFactory: CoordinatorFactoryImp())
        
        return (coordinator, controller)
    }
    
    func makeHomeCoordinator(navigationController: UINavigationController?) -> Coordinator {
        let coordinator = HomeCoordinator(
            router: router(navigationController),
            moduleFactory: ModuleFactoryImp(),
            coordinatorFactory: CoordinatorFactoryImp()
        )
        
        return coordinator
    }
    
    private func router(_ navigationController: UINavigationController?) -> Router {
        let navigationController = navigationController ?? UINavigationController()
        
        return RouterImp(navigationController: navigationController)
    }
}
