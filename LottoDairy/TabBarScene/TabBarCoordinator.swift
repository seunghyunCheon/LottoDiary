//
//  TabbarCoordinator.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

final class TabBarCoordinator: BaseCoordinator {
    
    private let tabBarFlow: TabBarFlowProtocol
    private let coordinatorFactory: CoordinatorFactory
    
    init(tabBarFlow: TabBarFlowProtocol, coordinatorFactory: CoordinatorFactory) {
        self.tabBarFlow = tabBarFlow
        self.coordinatorFactory = coordinatorFactory
    }
}
