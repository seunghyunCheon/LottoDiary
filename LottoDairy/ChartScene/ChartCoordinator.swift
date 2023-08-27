//
//  ChartCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/27.
//

final class ChartCoordinator: BaseCoordinator {

    private let router: Router
    private let moduleFactory: ChartModuleFactory
    private let coordinatorFactory: CoordinatorFactory

    init(router: Router, moduleFactory: ChartModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        let chartFlow = moduleFactory.makeChartFlow()
        router.setRootModule(chartFlow)
    }
}
