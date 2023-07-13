//
//  TabbarController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit

final class TabBarController: UITabBarController, TabBarFlowProtocol {
    
    var onViewWillAppear: ((UINavigationController) -> ())?
    
    var onHomeFlowSelect: ((UINavigationController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controller = viewControllers?[1] as? UINavigationController {
            onViewWillAppear?(controller)
        }
    }
    
    func configureViewControllers() {
        self.viewControllers = TabBarComponents.allCases.map { makeTabBarViewControllers($0) }
        selectedIndex = 1
    }
    
    private func makeTabBarViewControllers(_ type: TabBarComponents) -> UINavigationController {
        let viewController = UINavigationController()
        viewController.tabBarItem.title = type.title
        viewController.tabBarItem.image = UIImage(systemName: type.systemName)
        return viewController
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        
        // 현재 문제 : UITabBarControllerDelegate이 작동하지 않는다.
        if selectedIndex == 1 {
            onHomeFlowSelect?(controller)
        }
    }
}
