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
    private var imageView: UIImageView?

    private let imageViewSize: CGFloat = 37

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(first firstVerticalText: String, second secondVerticalText: String, alignment: NSTextAlignment = .left) {
        self.init(frame: .zero)

        self.firstLabel = GmarketSansLabel(text: firstVerticalText,
                                           alignment: alignment,
                                           size: .title2,
                                           weight: .medium)
        self.secondLabel = GmarketSansLabel(text: secondVerticalText,
                                            alignment: alignment,
                                            size: .title2,
                                            weight: .medium)
        setupCommon()
        setupVerticalView()
    }

    convenience init(first firstHorizontalText: String, second secondHorizontalText: String, image: UIImage?) {
        self.init(frame: .zero)

        self.imageView = UIImageView(image: image)
        self.firstLabel = GmarketSansLabel(text: firstHorizontalText,
                                           alignment: .center,
                                           size: .callout,
                                           weight: .medium)
        self.secondLabel = GmarketSansLabel(text: secondHorizontalText,
                                            alignment: .left,
                                            size: .title2,
                                            weight: .bold)
        setupCommon()
        setupImageView()
        setupHorizontalView()
        configureMoneyInformationView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCommon() {
        guard let firstLabel = firstLabel, let secondLabel = secondLabel else { return }
        firstLabel.translatesAutoresizingMaskIntoConstraints = false
        secondLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubviews([firstLabel, secondLabel])
    }

    private func setupImageView() {
        guard let imageView = imageView else { return }
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
    }

    private func setupVerticalView() {
        guard let firstLabel = firstLabel, let secondLabel = secondLabel else { return }
        let gab: CGFloat = 20

        NSLayoutConstraint.activate([
            firstLabel.topAnchor.constraint(equalTo: topAnchor),
            firstLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            firstLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            secondLabel.topAnchor.constraint(equalTo: firstLabel.bottomAnchor, constant: gab),
            secondLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            secondLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func setupHorizontalView() {
        guard let firstLabel = firstLabel, let secondLabel = secondLabel, let imageView = imageView else { return }
        let leadingConstant: CGFloat = 15
        let firstLabelWidth: CGFloat = 80
        let firstLabelGab: CGFloat = 5
        let secondLabelGab: CGFloat = 13

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConstant),
            imageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            firstLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: firstLabelGab),
            firstLabel.widthAnchor.constraint(equalToConstant: firstLabelWidth),
            firstLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor),

            secondLabel.leadingAnchor.constraint(equalTo: firstLabel.trailingAnchor, constant: secondLabelGab),
            secondLabel.centerYAnchor.constraint(equalTo: imageView.centerYAnchor)
        ])
    }

    private func configureMoneyInformationView() {
        guard let imageView = imageView else { return }
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageViewSize / 2
    }
}
