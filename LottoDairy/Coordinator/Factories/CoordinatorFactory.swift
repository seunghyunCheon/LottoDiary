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
    func makeTabbarCoordinator() -> (configurator: Coordinator & TabBarCoordinatorFinishable, toPresent: Presentable?)
    func makeHomeCoordinator(navigationController: UINavigationController?) -> Coordinator & HomeCoordinatorFinishable
    func makeLottoQRCoordinator(navigationController: UINavigationController?) -> Coordinator
    func makeCalendarCoordinator(navigationController: UINavigationController?) -> Coordinator
    func makeChartCoordinator(navigationController: UINavigationController?) -> Coordinator
    func makeRandomNumberCoordinator(navigationController: UINavigationController?) -> Coordinator
}
