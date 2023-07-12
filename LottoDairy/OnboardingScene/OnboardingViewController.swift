//
//  OnboardingViewController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/10.
//

import UIKit

final class OnboardingViewController: UIViewController, OnboardingFlowProtocol {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "목표금액을 설정해 주세요!"
        label.font = .gmarketSans(size: .title2, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .designSystem(.white)
        
        return label
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "매달 지출목표를 설정해서 지출을 줄여보세요."
        label.font = .gmarketSans(size: .body, weight: .medium)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .designSystem(.white)
        
        return label
    }()
    
    private let goalSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle("목표 입력하기", for: .normal)
        button.titleLabel?.font = .gmarketSans(size: .body, weight: .medium)
        button.setTitleColor(.designSystem(.white), for: .normal)
        button.backgroundColor = .designSystem(.mainOrange)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let settingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    var onSetting: (() -> Void)?
    
    override func viewDidLoad() {
        setupRootView()
        setupLayout()
    }
    
    private func setupRootView() {
        self.view.backgroundColor = .designSystem(.gray17181D)
    }
    
    private func setupLayout() {
        self.view.addSubview(settingStackView)
        settingStackView.addArrangedSubview(titleLabel)
        settingStackView.addArrangedSubview(subTitleLabel)
        settingStackView.addArrangedSubview(goalSettingButton)
        
        self.view.addSubview(settingStackView)
        
        NSLayoutConstraint.activate([
            settingStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            settingStackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            goalSettingButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5),
            goalSettingButton.heightAnchor.constraint(equalTo: goalSettingButton.widthAnchor, multiplier: 0.25)
        ])
    }
}
