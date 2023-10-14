//
//  OnboardingViewController.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/10.
//

import UIKit
import Combine

final class OnboardingViewController: UIViewController, OnboardingFlowProtocol {
    
    private enum Constant {
        static let title = "목표금액을 설정해 주세요!"
        static let subtitle = "매달 지출목표를 설정해서 지출을 줄여보세요."
        static let goalSettingText = "목표 입력하기"
    }
    
    private let titleLabel = GmarketSansLabel(text: Constant.title, size: .title2, weight: .bold)
    
    private let subTitleLabel = GmarketSansLabel(text: Constant.subtitle, size: .body, weight: .medium)
    
    private let goalSettingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constant.goalSettingText, for: .normal)
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
    
    var viewModel: OnboardingViewModel
    var onSetting: (() -> Void)?
    
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers

    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupRootView()
        setupLayout()
        bindViewModel()
    }
    
    private func setupRootView() {
        view.backgroundColor = .designSystem(.backgroundBlack)
    }
    
    private func setupLayout() {
        view.addSubview(settingStackView)
        settingStackView.addArrangedSubview(titleLabel)
        settingStackView.addArrangedSubview(subTitleLabel)
        settingStackView.addArrangedSubview(goalSettingButton)
        
        view.addSubview(settingStackView)
        
        NSLayoutConstraint.activate([
            settingStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            settingStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            goalSettingButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            goalSettingButton.heightAnchor.constraint(equalTo: goalSettingButton.widthAnchor, multiplier: 0.25)
        ]) 
    }
    
    private func bindViewModel() {
        let input = OnboardingViewModel.Input(
            goalSettingButtonDidTab: goalSettingButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.settingPageRequested
            .sink { [weak self] in
                self?.onSetting?()
            }
            .store(in: &cancellables)
    }
}
