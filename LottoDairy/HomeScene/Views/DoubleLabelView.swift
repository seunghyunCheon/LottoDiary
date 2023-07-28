//
//  DoubleLabelStackView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/28.
//

import UIKit

class DoubleLabelView: UIView {

    private var firstLabel: UILabel?
    private var secondLabel: UILabel?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupCommonView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        setupCommonView()
    }

    convenience init(title: String, money: String, backgroundColor: UIColor) {
        self.init(frame: .zero)

        self.firstLabel = GmarketSansLabel(text: title, size: .callout, weight: .medium)
        self.secondLabel = GmarketSansLabel(text: money, size: .callout, weight: .medium)

        configureMoneyInformationView(backgroundColor)
    }

    convenience init(first firstText: String, second secondText: String, alignment: NSTextAlignment = .left) {
        self.init(frame: .zero)

        self.firstLabel = GmarketSansLabel(text: firstText, alignment: alignment, size: .title2, weight: .medium)
        self.secondLabel = GmarketSansLabel(text: secondText, alignment: alignment, size: .title2, weight: .medium)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCommonView() {
        guard let firstLabel = firstLabel, let secondLabel = secondLabel else { return }
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubviews([firstLabel, secondLabel])

        let gabOfTop: CGFloat = 20
        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: topAnchor),
            firstLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: gabOfTop),
            secondLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func configureMoneyInformationView(_ backColor: UIColor) {
        clipsToBounds = true
        layer.cornerRadius = 20
        backgroundColor = backColor
    }
}
