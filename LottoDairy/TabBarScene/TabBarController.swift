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
    
    var onLottoQRFlowSelect: ((UINavigationController) -> ())?

    var onCalendarFlowSelect: ((UINavigationController) -> ())?

    var onChartFlowSelect: ((UINavigationController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBar()
        configureViewControllers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let controller = viewControllers?[1] as? UINavigationController {
            onViewWillAppear?(controller)
        }
    }
    
    private func configureTabBar() {
        setValue(TabBarView(frame: tabBar.frame), forKey: "tabBar")
        delegate = self
    }
    
    private func configureViewControllers() {
        viewControllers = TabBarComponents.allCases.map { makeTabBarNavigationControllers($0) }
        selectedIndex = TabBarComponents.home.rawValue
    }
    
    private func makeTabBarNavigationControllers(_ type: TabBarComponents) -> UINavigationController {
        let viewController = UINavigationController()
        viewController.tabBarItem.title = type.title
        viewController.tabBarItem.image = UIImage(systemName: type.systemName)
        return viewController
    }
}

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let controller = viewControllers?[selectedIndex] as? UINavigationController else { return }

        switch TabBarComponents(rawValue: selectedIndex) {
        case .calendar:
            onCalendarFlowSelect?(controller)
        case .home:
            onHomeFlowSelect?(controller)
        case .chart:
            onChartFlowSelect?(controller)
        default:
            onHomeFlowSelect?(controller)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        return TabBarComponents(rawValue: selectedIndex) == .empty ? false : true
    }
}
