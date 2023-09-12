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
        tabBarFlow.onLottoQRFlowSelect = runLottoQRFlow()
        tabBarFlow.onCalendarFlowSelect = runCalendarFlow()
    }
    
    private func runHomeFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let homeCoordinator = coordinatorFactory.makeHomeCoordinator(navigationController: navController)
                addDependency(homeCoordinator)
                homeCoordinator.start()
            }
        }
    }

    private func runLottoQRFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let lottoQRCoordinator = coordinatorFactory.makeLottoQRCoordinator(navigationController: navController)
                addDependency(lottoQRCoordinator)
                lottoQRCoordinator.start()
            }
        }
    }

    private func runCalendarFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let calendarCoordinator = coordinatorFactory.makeCalendarCoordinator(navigationController: navController)
                addDependency(calendarCoordinator)
                calendarCoordinator.start()
            }

        }
    }
}
