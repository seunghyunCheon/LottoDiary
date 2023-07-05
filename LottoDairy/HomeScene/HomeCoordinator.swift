//
//  HomeCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

final class HomeCoordinator: BaseCoordinator {
    
    private let router: Router
    private let moduleFactory: HomeModuleFactory
    private let coordinatorFactory: CoordinatorFactory
    
    init(router: Router, moduleFactory: HomeModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
    }
    
    override func start() {
        
    }
}
