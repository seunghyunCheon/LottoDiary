//
//  RandomNumberCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 3/15/24.
//

final class RandomNumberCoordinator: BaseCoordinator {
    private let router: Router
    private let moduleFactory: RandomNumberModuleFactory
    private let coordinatorFactory: CoordinatorFactory

    init(
        router: Router,
        moduleFactory: RandomNumberModuleFactory,
        coordinatorFactory: CoordinatorFactory
    ) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        let randomNumberFlow = moduleFactory.makeRandomNumberFlow()
        router.setRootModule(randomNumberFlow)
    }
}
