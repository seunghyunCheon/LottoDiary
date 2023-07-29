//
//  InformationStackView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/27.
//

import UIKit

final class InformationView: UIView {

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

    init() {
        super.init(frame: .zero)

        setupInformationStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInformationStackView() {
        let nickNameView = setupNickNameView()
        let moneyInformationStackView = setupMoneyInformationStackView()
        addSubviews([nickNameView, explanationLabel, moneyInformationStackView])

        let height = UIScreen.main.bounds.height * 0.35
        let nickNameViewHeight: CGFloat = height * 0.127
        let explanationLabelGap: CGFloat = height * 0.1
        let explanationLabelHeight: CGFloat = height * 0.27
        let moneyInformationStackViewGap: CGFloat = height * 0.03

        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height),
            nickNameView.topAnchor.constraint(equalTo: topAnchor),
            nickNameView.leadingAnchor.constraint(equalTo: leadingAnchor),
            nickNameView.trailingAnchor.constraint(equalTo: trailingAnchor),
            nickNameView.heightAnchor.constraint(equalToConstant: nickNameViewHeight),

            explanationLabel.topAnchor.constraint(equalTo: nickNameView.bottomAnchor, constant: explanationLabelGap),
            explanationLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            explanationLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            explanationLabel.heightAnchor.constraint(equalToConstant: explanationLabelHeight),

            moneyInformationStackView.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: moneyInformationStackViewGap),
            moneyInformationStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            moneyInformationStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            moneyInformationStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
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
}
