//
//  HomeViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

import UIKit

final class HomeViewController: UIViewController, HomeFlowProtocol {
    
    var onMyInformation: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
    }
}
