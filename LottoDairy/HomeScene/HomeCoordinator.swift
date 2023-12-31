//
//  HomeCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

protocol HomeCoordinatorFinishable: AnyObject {
    var onSettingFlow: (() -> Void)? { get set }
}

final class HomeCoordinator: BaseCoordinator, HomeCoordinatorFinishable {

    var onSettingFlow: (() -> Void)?
    private let router: Router
    private let moduleFactory: HomeModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, moduleFactory: HomeModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        var homeFlow = moduleFactory.makeHomeFlow()
        homeFlow.onSetting = { [weak self] in
            self?.onSettingFlow?()
        }
        router.setRootModule(homeFlow)
    }
}
