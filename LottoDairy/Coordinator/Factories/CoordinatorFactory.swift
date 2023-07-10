//
//  CoordinatorFactory.swift
//  LottoDairy
//
//  Created by Brody on 2023/06/30.
//

import UIKit

protocol CoordinatorFactory {
    func makeOnboardingCoordinator(router: Router) -> Coordinator & OnboardingCoordinatorFinishable
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?)
    func makeHomeCoordinator(navigationController: UINavigationController?) -> Coordinator
}
