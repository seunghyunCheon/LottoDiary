//
//  TabbarController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit

final class TabBarController: UITabBarController, TabBarFlowProtocol {
    
    var onViewDidLoad: ((UINavigationController) -> ())?
    
    var onHomeFlowSelect: ((UINavigationController) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
