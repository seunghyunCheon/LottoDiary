//
//  CalendarCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

final class CalendarCoordinator: BaseCoordinator {

    private let router: Router
    private let moduleFactory: CalendarModuleFactory
    private let coordinatorFactory: CoordinatorFactory

    init(router: Router, moduleFactory: CalendarModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        let calendarFlow = moduleFactory.makeCalendarFlow()
        router.setRootModule(calendarFlow)
    }
}
