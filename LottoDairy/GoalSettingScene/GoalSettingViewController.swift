//
//  GoalSettingViewController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/17.
//

import UIKit

final class GoalSettingViewController: UIViewController, GoalSettingFlowProtocol {
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "내 정보"
        label.font = .gmarketSans(size: .title1, weight: .bold)
        label.textColor = .designSystem(.white)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = .gmarketSans(size: .subheadLine, weight: .bold)
        label.textColor = .designSystem(.white)
        
        return label
    }()
    
    private let nickNameTextField: LottoDiaryTextField = {
        return LottoDiaryTextField(placeholder: "Jane", type: .letter, align: .right)
    }()
    
    private let nickNameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.backgroundColor = .designSystem(.gray2B2C35)
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let goalSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "6월 목표금액"
        label.font = .gmarketSans(size: .subheadLine, weight: .bold)
        label.textColor = .designSystem(.white)
        label.textAlignment = .left
        
        return label
    }()
    
    private let goalSettingTextField: UITextField = {
        return LottoDiaryTextField(placeholder: "목표금액을 입력해주세요", type: .number, align: .right)
    }()
    
    private let goalSettingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.backgroundColor = .designSystem(.gray2B2C35)
        stackView.layer.cornerRadius = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private let notificationLabel: UILabel = {
        let label = UILabel()
        label.text = "일정 주기마다 로또 경고 알림"
        label.font = .gmarketSans(size: .title2, weight: .bold)
        label.textColor = .designSystem(.white)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let notificationTextField: LottoDiaryTextField = {
        let textField = LottoDiaryTextField(placeholder: "주기를 선택해주세요", type: .letter, align: .left)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    // MARK: - Properties
    
    var onMain: (() -> Void)?
    private let notificationCycleList = ["설정 안함", "하루", "일주일", "한달"]
    
    override func viewDidLoad() {
        setupRootView()
        setupLayout()
        createPickerView()
    }
    
    private func setupRootView() {
        view.backgroundColor = .designSystem(.backgroundBlack)
    }
    
    private func setupLayout() {
        let safe = view.safeAreaLayoutGuide
        
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            titleLabel.topAnchor.constraint(equalTo: safe.topAnchor, constant: 10)
        ])
        
        view.addSubview(nickNameStackView)
        nickNameStackView.addArrangedSubview(nickNameLabel)
        nickNameStackView.addArrangedSubview(nickNameTextField)
        NSLayoutConstraint.activate([
            nickNameStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            nickNameStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            nickNameStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
        ])
        
        view.addSubview(goalSettingStackView)
        goalSettingStackView.addArrangedSubview(goalSettingLabel)
        goalSettingStackView.addArrangedSubview(goalSettingTextField)
        NSLayoutConstraint.activate([
            goalSettingStackView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            goalSettingStackView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -10),
            goalSettingStackView.topAnchor.constraint(equalTo: nickNameStackView.bottomAnchor, constant: 20)
        ])
        
        view.addSubview(notificationLabel)
        NSLayoutConstraint.activate([
            notificationLabel.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            notificationLabel.topAnchor.constraint(equalTo: goalSettingStackView.bottomAnchor, constant: 30)
        ])
        
        view.addSubview(notificationTextField)
        NSLayoutConstraint.activate([
            notificationTextField.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 10),
            notificationTextField.topAnchor.constraint(equalTo: notificationLabel.bottomAnchor, constant: 20)
        ])
    }
}
