//
//  CoordinatorFactoryImp.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

final class CoordinatorFactoryImp: CoordinatorFactory {
    
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?) {
        let controller = TabBarController()
        let coordinator = TabBarCoordinator(tabBarFlow: controller, coordinatorFactory: CoordinatorFactoryImp())
        
        return (coordinator, controller)
    }
    
//    func makeProfileCoordinator(router: Router) -> Coordinator & ProfileCoordinatorOutput {
//        return 
//    }
}
