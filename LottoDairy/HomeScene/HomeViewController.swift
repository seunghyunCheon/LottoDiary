//
//  HomeViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

import UIKit

final class HomeViewController: UIViewController, HomeFlowProtocol {
    
    var onSetting: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        configureView()
    }

    private func setupView() {
        let homeView = HomeView(frame: .zero)
        view.addSubview(homeView)

        let horizontalConstant: CGFloat = view.frame.width * 0.054
        let bottomAnchor: CGFloat = 100

        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: horizontalConstant),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -horizontalConstant),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomAnchor)
        ])
    }

    private func configureView() {
        self.navigationController?.isNavigationBarHidden = true
    }
}
