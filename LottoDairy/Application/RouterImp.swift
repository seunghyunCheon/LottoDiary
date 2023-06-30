//
//  RouterImp.swift
//  LottoDairy
//
//  Created by Sunny on 2023/06/30.
//

import UIKit

final class RouterImp: Router {
    
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toPresent() -> UIViewController? {
        return navigationController
    }
    
    func present(_ module: Presentable?, animated: Bool) {
        
        guard let controller = module?.toPresent() else { return }
        navigationController?.present(controller, animated: animated)
    }
    
    func push(_ module: Presentable?, animated: Bool) {
        
        guard let controller = module?.toPresent(),
              (controller is UINavigationController == false) else {
            assertionFailure("Deprecated push UINavigationController.")
            return
        }
        
        navigationController?.pushViewController(controller, animated: animated)
    }
    
    func popModule(animated: Bool) {
        
        navigationController?.popViewController(animated: animated)
    }
    
    func dismissModule(animated: Bool, completion: (() -> Void)?) {
        
        navigationController?.dismiss(animated: animated, completion: completion)
    }
    
    func setRootModule(_ module: Presentable?) {
        
        guard let controller = module?.toPresent() else { return }
        navigationController?.setViewControllers([controller], animated: false)
    }
    
    func popToRootModule(animated: Bool) {
        
        navigationController?.popToRootViewController(animated: animated)
    }
}
