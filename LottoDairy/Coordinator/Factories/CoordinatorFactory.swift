//
//  CoordinatorFactory.swift
//  LottoDairy
//
//  Created by Brody on 2023/06/30.
//

import UIKit

protocol CoordinatorFactory {
    func makeOnboardingCoordinator(router: Router) -> Coordinator & OnboardingCoordinatorFinishable
    func makeGoalSettingCoordinator(router: Router) -> Coordinator & GoalSettingCoordinatorFinishable
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?)
    func makeHomeCoordinator(navigationController: UINavigationController?) -> Coordinator
    func makeLottoQRCoordinator(navigationController: UINavigationController?) -> Coordinator
    func makeChartCoordinator(navigationController: UINavigationController?) -> Coordinator
}
