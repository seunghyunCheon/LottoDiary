//
//  TabbarController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate, TabBarFlowProtocol {
    
    var onViewDidLoad: ((UINavigationController) -> ())?
    
    var onHomeFlowSelect: ((UINavigationController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        if let controller = viewControllers?.first as? UINavigationController {
            onViewDidLoad?(controller)
        }
    }
    
    func configureViewControllers() {
        
        let homeViewController = UINavigationController(rootViewController: HomeViewController())
        homeViewController.tabBarItem.title = "Home"
        self.viewControllers = [homeViewController]
        
        selectedIndex = 0
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        
        if selectedIndex == 0 {
            onHomeFlowSelect?(controller)
        }
    }
}
