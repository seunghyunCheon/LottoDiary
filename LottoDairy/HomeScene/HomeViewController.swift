//
//  HomeViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

import UIKit
import Combine

final class HomeViewController: UIViewController, HomeFlowProtocol {

    // MARK: Properties - UI
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    private let nickNameLabel: UILabel = {
        let label = GmarketSansLabel(size: .title2, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let settingButton: UIButton = {
        let button = UIButton()
        let gearImage = SystemName.setting.image
        button.setImage(gearImage, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false

        return button
    }()

    private let explanationLabel: DoubleLabelView = {
        let view = DoubleLabelView(type: .percent)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private lazy var goalLabel = DoubleLabelView(type: .goal)
    private lazy var purchaseLabel = DoubleLabelView(type: .buy)
    private lazy var winningLabel = DoubleLabelView(type: .win)

    private let imageLabel: UILabel = {
        let label = GmarketSansLabel(text: StringLiteral.imageTitle, alignment: .left, size: .title3, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false

        return label
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView(image: SystemName.photo.image)
        imageView.backgroundColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Constant.cornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let imageExplanationView: UIView = {
        let view = DoubleLabelView(won: "78000", riceSoup: "7.8")
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    var onSetting: (() -> Void)?

    private let viewModel: HomeViewModel

    private var viewWillAppearPublisher = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupScrollView()
        setupContentView()
        configureContentView()

        self.bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.viewWillAppearPublisher.send()
    }

    // MARK: Functions - Private
    private func configureView() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .designSystem(.backgroundBlack)
    }

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        guard let tabBarHeight = self.tabBarController?.tabBar.frame.height else { return }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -(tabBarHeight + 5)),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }

    private func setupContentView() {
        let informationView = setupInformationView()
        let imageInformationView = setupImageInformationView()
        contentView.addArrangedSubviews([informationView, imageInformationView])
    }

    private func setupInformationView() -> UIView {
        let informationView = UIView()

        let nickNameView = setupNickNameView()
        let moneyInformationStackView = setupMoneyInformationStackView()

        informationView.addSubviews([nickNameView, explanationLabel, moneyInformationStackView])

        let height = view.frame.height * 0.35
        let nickNameViewHeight: CGFloat = height * 0.127
        let explanationLabelGap: CGFloat = height * 0.07
        let moneyInformationStackViewGap: CGFloat = 10

        NSLayoutConstraint.activate([
            nickNameView.topAnchor.constraint(equalTo: informationView.topAnchor),
            nickNameView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
            nickNameView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor),
            nickNameView.heightAnchor.constraint(equalToConstant: nickNameViewHeight),

            explanationLabel.topAnchor.constraint(equalTo: nickNameView.bottomAnchor, constant: explanationLabelGap),
            explanationLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor),

            moneyInformationStackView.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: moneyInformationStackViewGap),
            moneyInformationStackView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
            moneyInformationStackView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor),
            moneyInformationStackView.bottomAnchor.constraint(equalTo: informationView.bottomAnchor)
        ])

        return informationView
    }

    private func setupNickNameView() -> UIView {
        let nickNameView: UIView = {
            let view = UIView()
            view.addSubviews([nickNameLabel, settingButton])
            view.translatesAutoresizingMaskIntoConstraints = false

            return view
        }()

        NSLayoutConstraint.activate([
            nickNameLabel.topAnchor.constraint(equalTo: nickNameView.topAnchor),
            nickNameLabel.leadingAnchor.constraint(equalTo: nickNameView.leadingAnchor),
            nickNameLabel.centerYAnchor.constraint(equalTo: settingButton.centerYAnchor),

            settingButton.topAnchor.constraint(equalTo: nickNameView.topAnchor),
            settingButton.leadingAnchor.constraint(equalTo: nickNameLabel.trailingAnchor, constant: 10)
        ])

        return nickNameView
    }

    private func getMoneyHorizontalStackView(label: UIView, type: AmountType) -> UIStackView {
        let imageView: UIImageView = {
            let imageView = UIImageView(image: type.image)
            let imageViewSize: CGFloat = view.frame.width * 0.095

            imageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = imageViewSize / 2
            imageView.backgroundColor = .blue
            return imageView
        }()

        let moneyHorizontalStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.addArrangedSubviews([imageView, label])
            stackView.axis = .horizontal
            stackView.distribution = .fillProportionally
            stackView.alignment = .center
            stackView.spacing = 15
            return stackView
        }()
        return moneyHorizontalStackView
    }

    private func setupMoneyInformationStackView() -> UIStackView {
        let moneyInformationStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.spacing = 15
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.backgroundColor = .designSystem(.gray2D2B35)
            stackView.clipsToBounds = true
            stackView.layer.cornerRadius = Constant.cornerRadius
            return stackView
        }()
        let goalStackView = getMoneyHorizontalStackView(label: goalLabel, type: .goal)
        let buyStackView = getMoneyHorizontalStackView(label: purchaseLabel, type: .buy)
        let winStackView = getMoneyHorizontalStackView(label: winningLabel, type: .win)
        moneyInformationStackView.addArrangedSubviews([goalStackView, buyStackView, winStackView])
        moneyInformationStackView.isLayoutMarginsRelativeArrangement = true
        moneyInformationStackView.layoutMargins = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

        return moneyInformationStackView
    }

    private func setupImageInformationView() -> UIView {
        let imageInformationView = UIView()
        imageInformationView.addSubviews([imageLabel, imageView, imageExplanationView])

        let height = view.frame.height * 0.344
        let topAchorGap: CGFloat = height * 0.04
        let imageViewHeight: CGFloat = height * 0.52

        NSLayoutConstraint.activate([
            imageInformationView.heightAnchor.constraint(equalToConstant: height),
            imageLabel.topAnchor.constraint(equalTo: imageInformationView.topAnchor),
            imageLabel.leadingAnchor.constraint(equalTo: imageInformationView.leadingAnchor),
            imageLabel.trailingAnchor.constraint(equalTo: imageInformationView.trailingAnchor),

            imageView.topAnchor.constraint(equalTo: imageLabel.bottomAnchor, constant: topAchorGap),
            imageView.leadingAnchor.constraint(equalTo: imageInformationView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageInformationView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageViewHeight),

            imageExplanationView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: topAchorGap),
            imageExplanationView.leadingAnchor.constraint(equalTo: imageInformationView.leadingAnchor),
            imageExplanationView.trailingAnchor.constraint(equalTo: imageInformationView.trailingAnchor)
        ])

        return imageInformationView
    }

    private func configureContentView() {
        let horizontalInset = view.frame.width * 0.054
        let spacing = view.frame.height * 0.04

        contentView.axis = .vertical
        contentView.spacing = spacing
        contentView.isLayoutMarginsRelativeArrangement = true
        contentView.layoutMargins = UIEdgeInsets(top: .zero, left: horizontalInset, bottom: .zero, right: horizontalInset)
    }

    private func bindViewModel() {
        let input = HomeViewModel.Input(viewWillAppearEvent: self.viewWillAppearPublisher)

        let output = viewModel.transform(from: input)

        self.explanationLabel.configureExplanationLabel(month: output.month)

        output.nickNameTextField
            .sink { name in
                self.nickNameLabel.text = name
            }
            .store(in: &cancellables)

        output.goalAmount
            .sink { goal in
                self.goalLabel.updateWonAmount(goal)
            }
            .store(in: &cancellables)

        output.purchaseAmount
            .sink { purchase in
                self.purchaseLabel.updateWonAmount(purchase)
            }
            .store(in: &cancellables)

        output.winningAmount
            .sink { winning in
                self.winningLabel.updateWonAmount(winning)
            }
            .store(in: &cancellables)

        output.percent
            .sink { percent in
                self.explanationLabel.configureExplanationLabel(percent: percent ?? 0)
            }
            .store(in: &cancellables)
    }
}

// MARK: Extension
extension HomeViewController {

    private enum SystemName: String {
        case setting = "gearshape"
        case photo = "photo"

        var image: UIImage? {
            return UIImage(systemName: self.rawValue)
        }
    }

    private enum Constant {
        static let cornerRadius: CGFloat = 15
    }

    private enum StringLiteral {
        static let imageTitle = "이 돈이면"
    }
}
