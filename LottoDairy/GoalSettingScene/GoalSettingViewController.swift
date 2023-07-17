//
//  GoalSettingViewController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/17.
//

import UIKit

final class GoalSettingViewController: UIViewController, GoalSettingFlowProtocol {
    
    var onMain: (() -> Void)?
    
    override func viewDidLoad() {
        view.backgroundColor = .red
        setupRootView()
    }
    
    private func setupRootView() {
        view.backgroundColor = .designSystem(.backgroundBlack)
    }
}
