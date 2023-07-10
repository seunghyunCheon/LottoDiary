//
//  OnboardingViewController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/10.
//

import UIKit

final class OnboardingViewController: UIViewController, OnboardingFlowProtocol {
    
    var onSetting: (() -> Void)?
    
    override func viewDidLoad() {
        self.view.backgroundColor = .red
    }
}
