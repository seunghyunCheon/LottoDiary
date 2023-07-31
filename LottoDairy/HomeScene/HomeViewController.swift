//
//  HomeViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

import UIKit

final class HomeViewController: UIViewController, HomeFlowProtocol {

    // MARK: Properties - View
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()

    // MARK: Properties - InformationView
    private let nickNameLabel: UILabel = {
        let label = GmarketSansLabel(text: "Brody님", size: .title2, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let settingButton: UIButton = {
        let button = UIButton()
        let gearImage = UIImage(systemName: "gearshape")
        button.setImage(gearImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let explanationLabel: UIView = {
        let view = DoubleLabelView(first: "7월 동안", second: "목표치의 75%를 사용하셨습니다.")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let goal = DoubleLabelView(first: "목표", second: "10,000원", image: nil)
    private let buy = DoubleLabelView(first: "구매 금액", second: "20,000원", image: nil)
    private let win = DoubleLabelView(first: "당첨 금액", second: "3,000원", image: nil)

    // MARK: Properties - ImageInformationView
    private let imageLabel: UILabel = {
        let label = GmarketSansLabel(text: "이 돈이면", alignment: .left, size: .title3, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let imageView: UIImageView = {
        let image = UIImage(systemName: "photo")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .systemYellow
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let imageExplanationView: UIView = {
        let view = DoubleLabelView(first: "78000원으로", second: "국밥 7.8개 그릇먹기 가능", alignment: .center)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var onSetting: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        setupScrollView()
        setupContentView()
    }

    private func setupInformationView() -> UIView {
        let informationView = UIView()

        let nickNameView = setupNickNameView()
        let moneyInformationStackView = setupMoneyInformationStackView()

        informationView.addSubviews([nickNameView, explanationLabel, moneyInformationStackView])

        let height = UIScreen.main.bounds.height * 0.35
        let nickNameViewHeight: CGFloat = height * 0.127
        let explanationLabelGap: CGFloat = height * 0.1
        let explanationLabelHeight: CGFloat = height * 0.27
        let moneyInformationStackViewGap: CGFloat = height * 0.03

        NSLayoutConstraint.activate([
            informationView.heightAnchor.constraint(equalToConstant: height),
            nickNameView.topAnchor.constraint(equalTo: informationView.topAnchor),
            nickNameView.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
            nickNameView.trailingAnchor.constraint(equalTo: informationView.trailingAnchor),
            nickNameView.heightAnchor.constraint(equalToConstant: nickNameViewHeight),

            explanationLabel.topAnchor.constraint(equalTo: nickNameView.bottomAnchor, constant: explanationLabelGap),
            explanationLabel.leadingAnchor.constraint(equalTo: informationView.leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: informationView.trailingAnchor),
            explanationLabel.heightAnchor.constraint(equalToConstant: explanationLabelHeight),

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

    private func setupMoneyInformationStackView() -> UIStackView {
        let moneyInformationStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.distribution = .fillEqually
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.backgroundColor = .designSystem(.gray2D2B35)
            stackView.clipsToBounds = true
            stackView.layer.cornerRadius = 15
            return stackView
        }()
        moneyInformationStackView.addArrangedSubviews([goal, buy, win])

        return moneyInformationStackView
    }

    private func setupImageInformationView() -> UIView {
        let imageInformationView = UIView()
        imageInformationView.addSubviews([imageLabel, imageView, imageExplanationView])

        let height = UIScreen.main.bounds.height * 0.344
        let topAchorGap: CGFloat = height * 0.07
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

    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupContentView() {
        let informationView = setupInformationView()
        let imageInformationView = setupImageInformationView()
        contentView.addArrangedSubviews([informationView, imageInformationView])

        contentView.axis = .vertical
        contentView.spacing = 40
    }

    private func configureView() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .designSystem(.backgroundBlack)
    }
}
