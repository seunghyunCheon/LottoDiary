//
//  TabbarCoordinator.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit

protocol TabBarCoordinatorFinishable: AnyObject {
    var onSettingFlow: (() -> Void)? { get set }
}

final class TabBarCoordinator: BaseCoordinator, TabBarCoordinatorFinishable {

    var onSettingFlow: (() -> Void)?
    private let tabBarFlow: TabBarFlowProtocol
    private let coordinatorFactory: CoordinatorFactory
    
    init(tabBarFlow: TabBarFlowProtocol, coordinatorFactory: CoordinatorFactory) {
        self.tabBarFlow = tabBarFlow
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        tabBarFlow.onViewWillAppear = runHomeFlow()
        tabBarFlow.onHomeFlowSelect = runHomeFlow()
        tabBarFlow.onCalendarFlowSelect = runCalendarFlow()
        tabBarFlow.onLottoQRFlowSelect = runLottoQRFlow()
        tabBarFlow.onChartFlowSelect = runChartFlow()
        tabBarFlow.onPermissionDeniedAlert = runPermissionDeniedAlert()
    }

    private func runPermissionDeniedAlert() -> ((UINavigationController, UIAlertController) -> ()) {
        return { (navController, alertController) in
            navController.present(alertController, animated: true)
        }
    }

    private func runHomeFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let homeCoordinator = coordinatorFactory.makeHomeCoordinator(navigationController: navController)
                homeCoordinator.onSettingFlow = { [weak self] in
                    self?.onSettingFlow?()
                }
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

    private func runChartFlow() -> ((UINavigationController) -> ()) {
        return { [unowned self] navController in
            if navController.viewControllers.isEmpty == true {
                let chartCoordinator = coordinatorFactory.makeChartCoordinator(navigationController: navController)
                addDependency(chartCoordinator)
                chartCoordinator.start()
            }
        }
    }
}
