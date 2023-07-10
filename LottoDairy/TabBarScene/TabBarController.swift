//
//  TabbarController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit

final class TabBarController: UITabBarController, UITabBarControllerDelegate, TabBarFlowProtocol {
    
    var onViewWillAppear: ((UINavigationController) -> ())?
    
    var onHomeFlowSelect: ((UINavigationController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controller = viewControllers?.first as? UINavigationController {
            onViewWillAppear?(controller)
        }
    }
    
    func configureViewControllers() {
        
        let homeViewController = UINavigationController()
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
