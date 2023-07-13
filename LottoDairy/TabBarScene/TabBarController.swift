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
        self.viewControllers = TabBarComponents.allCases.map { makeTabBarViewControllers($0) }
        selectedIndex = 1
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }
        
        // 현재 문제 : 아래 코드가 실행되지 않아 flow 연결이 되지 않는다.
        if selectedIndex == 1 {
            onHomeFlowSelect?(controller)
        }
    }
    
    // MARK: Functions - Private
    private func makeTabBarViewControllers(_ type: TabBarComponents) -> UINavigationController {
        let viewController = UINavigationController()
        viewController.tabBarItem.title = type.title
        viewController.tabBarItem.image = UIImage(systemName: type.systemName)
        return viewController
    }
}
