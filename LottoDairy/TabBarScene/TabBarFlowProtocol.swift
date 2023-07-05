//
//  TabbarFlowProtocol.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/05.
//

import UIKit

protocol TabBarFlowProtocol: AnyObject {
    var onViewDidLoad: ((UINavigationController) -> ())? { get set }
    var onHomeFlowSelect: ((UINavigationController) -> ())? { get set }
}
