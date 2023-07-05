//
//  CoordinatorFactory.swift
//  LottoDairy
//
//  Created by Brody on 2023/06/30.
//

import UIKit

protocol CoordinatorFactory {
    
    func makeTabbarCoordinator() -> (configurator: Coordinator, toPresent: Presentable?)
    
//    func makeProfileCoordinator(router: Router) -> Coordinator & ProfileCoordinatorOutput
    
    func makeHomeCoordinator(navigationController: UINavigationController?) -> Coordinator
}
