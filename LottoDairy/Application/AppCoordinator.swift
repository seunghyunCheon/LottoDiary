//
//  AppCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/06/30.
//

import Foundation

final class AppCoordinator: BaseCoordinator {

    private let coordinatorFactory: CoordinatorFactory
    private let moduleFactory: AppSetupModuleFactory
    private let router: Router

    init(router: Router,
         coordinatorFactory: CoordinatorFactory,
         moduleFactory: AppSetupModuleFactory
    ) {
        self.router = router
        self.coordinatorFactory = coordinatorFactory
        self.moduleFactory = moduleFactory
    }

    override func start() {
        runSetup()
    }

    private func runSetup() {
        // 결과 없는 로또 조회 -> 업데이트
        let lottoValidationModule = moduleFactory.makeLottoValidationFlow()
        lottoValidationModule.updateLottosWithNoResult()

        // 유저 정보 있는지 검색
        let userSetupModule = moduleFactory.makeUserSetupFlow()
        // 유저 정보 탐색 끝났으면 -> 화면 연결
        switch userSetupModule.instructor {
        case .main:
            self.runMainFlow()
        case .onboarding:
            self.runOnboardingFlow()
        }
    }

    private func runOnboardingFlow() {
        let coordinator = coordinatorFactory.makeOnboardingCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.runGoalSettingFlow()
        }
        addDependency(coordinator)
        coordinator.start()
    }

    func runGoalSettingFlow() {
        let coordinator = coordinatorFactory.makeGoalSettingCoordinator(router: router)
        coordinator.finishFlow = { [weak self, weak coordinator] in
            self?.removeDependency(coordinator)
            self?.runMainFlow()
        }
        addDependency(coordinator)
        coordinator.start()
    }

    private func runMainFlow() {
        let (coordinator, module) = coordinatorFactory.makeTabbarCoordinator()
        coordinator.onSettingFlow = { [weak self] in
            self?.runGoalSettingFlow()
        }
        addDependency(coordinator)
        router.setRootModule(module)
        coordinator.start()
    }
}
