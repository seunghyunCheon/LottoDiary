//
//  TabbarCoordinator.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit

final class TabBarCoordinator: BaseCoordinator {
    
    private let tabBarFlow: TabBarFlowProtocol
    private let coordinatorFactory: CoordinatorFactory
    
    init(tabBarFlow: TabBarFlowProtocol, coordinatorFactory: CoordinatorFactory) {
        self.tabBarFlow = tabBarFlow
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        tabBarFlow.onViewWillAppear = runHomeFlow()
        tabBarFlow.onHomeFlowSelect = runHomeFlow()
    }
    
    private func runHomeFlow() -> ((UINavigationController) -> ()) {
        
        return { [unowned self] navController in
          if navController.viewControllers.isEmpty == true {
              let homeCoordinator = self.coordinatorFactory.makeHomeCoordinator(navigationController: navController)
            self.addDependency(homeCoordinator)
            homeCoordinator.start()
          }
        }
    }
}
