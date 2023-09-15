//
//  AddLottoViewController.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import UIKit

final class AddLottoViewController: UIViewController, AddLottoViewProtocol {
    
    private var halfModalTransitioningDelegate = HalfModalTransitioningDelegate()
    
    private let titleLabel: UILabel = {
        let label = LottoLabel(text: "로또 종류", font: .gmarketSans(size: .title2, weight: .bold))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lottoSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["로또", "스피또"])
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.designSystem(.whiteEAE9EE)!, NSAttributedString.Key.font: UIFont.gmarketSans(size: .body, weight: .bold)], for: .selected)
        
         segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.designSystem(.grayA09FA7)!, NSAttributedString.Key.font: UIFont.gmarketSans(size: .body, weight: .bold)], for: .normal)
        
        segmentedControl.selectedSegmentTintColor = .designSystem(.gray4D4D59)
        segmentedControl.backgroundColor = .designSystem(.gray2B2C35)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    private let purchaseAmountLabel: UILabel = {
        let label = LottoLabel(text: "구입금액", font: .gmarketSans(size: .caption, weight: .medium))
        return label
    }()
    
    private let purchaseTextField: UITextField = {
        let textField = LottoDiaryTextField(
            placeholder: "구매금액을 입력해주세요",
            type: .number,
            align: .left
        )
        return textField
    }()
    
    private let purchaseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let winningLabel: UILabel = {
        let label = LottoLabel(text: "당첨금액", font: .gmarketSans(size: .caption, weight: .medium))
        return label
    }()
    
    private let winningTextField: UITextField = {
        let textField = LottoDiaryTextField(
            placeholder: "당첨금액을 입력해주세요",
            type: .number,
            align: .left
        )
        return textField
    }()
    
    private let winningStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .gmarketSans(size: .body, weight: .medium)
        button.setTitle("확인", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.alpha = 0.3
        button.backgroundColor = UIColor.black
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .gmarketSans(size: .body, weight: .medium)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .designSystem(.gray2D2B35)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupModalStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootView()
        setupLayout()
    }
    
    override func viewDidLayoutSubviews() {
        self.okButton.layer.cornerRadius = 5
        self.cancelButton.layer.cornerRadius = 5
    }
    
    private func setupModalStyle() {
        modalPresentationStyle = .custom
        modalTransitionStyle = .coverVertical
        transitioningDelegate = halfModalTransitioningDelegate
    }
    
    private func setupRootView() {
        self.view.backgroundColor = .designSystem(.backgroundBlack)
    }
    
    private func setupLayout() {
        self.view.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20)
        ])
        
        self.view.addSubview(self.lottoSegmentedControl)
        NSLayoutConstraint.activate([
            self.lottoSegmentedControl.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 20),
            self.lottoSegmentedControl.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            self.lottoSegmentedControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            self.lottoSegmentedControl.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.view.addSubview(self.purchaseStackView)
        self.purchaseStackView.addArrangedSubview(self.purchaseAmountLabel)
        self.purchaseStackView.addArrangedSubview(self.purchaseTextField)
        NSLayoutConstraint.activate([
            self.purchaseStackView.topAnchor.constraint(equalTo: self.lottoSegmentedControl.bottomAnchor, constant: 25),
            self.purchaseStackView.leadingAnchor.constraint(equalTo: self.lottoSegmentedControl.leadingAnchor),
            self.purchaseStackView.trailingAnchor.constraint(equalTo: self.lottoSegmentedControl.trailingAnchor)
        ])
        
        self.view.addSubview(self.winningStackView)
        self.winningStackView.addArrangedSubview(self.winningLabel)
        self.winningStackView.addArrangedSubview(self.winningTextField)
        NSLayoutConstraint.activate([
            self.winningStackView.topAnchor.constraint(equalTo: self.purchaseStackView.bottomAnchor, constant: 25),
            self.winningStackView.leadingAnchor.constraint(equalTo: self.lottoSegmentedControl.leadingAnchor),
            self.winningStackView.trailingAnchor.constraint(equalTo: self.lottoSegmentedControl.trailingAnchor)
        ])
        
        self.view.addSubview(self.buttonStackView)
        self.buttonStackView.addArrangedSubview(self.okButton)
        self.buttonStackView.addArrangedSubview(self.cancelButton)
        NSLayoutConstraint.activate([
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            self.buttonStackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            self.okButton.widthAnchor.constraint(equalToConstant: 90),
            self.okButton.heightAnchor.constraint(equalToConstant: 35),
            
            self.cancelButton.widthAnchor.constraint(equalToConstant: 90),
            self.cancelButton.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
}
