//
//  DoubleLabelStackView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/28.
//

import UIKit

class DoubleLabelView: UIView {

    private var firstLabel = UILabel()
    private var secondLabel = UILabel()
    private var imageView: UIImageView?

    private let imageViewSize: CGFloat = 37

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(month: String, percent: String) {
        self.init(frame: .zero)

        firstLabel.attributedText(first: "\(month)월", second: "동안", secondFontSize: .callout)
        secondLabel.attributedText(first: "목표치의 \(percent)%", second: "를 사용하셨습니다.", secondFontSize: .callout)

        firstLabel.textAlignment = .left
        secondLabel.textAlignment = .left
        setupCommon()
        setupVerticalView()
    }

    convenience init(won: String, riceSoup: String) {
        self.init(frame: .zero)

        firstLabel.attributedText(first: "\(won)원", second: "으로", secondFontSize: .title3)
        secondLabel.attributedText(first: "국밥 \(riceSoup) 그릇", second: "먹기 가능", secondFontSize: .title3)

        firstLabel.textAlignment = .center
        secondLabel.textAlignment = .center
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
                                            size: .title3,
                                            weight: .medium)
        setupCommon()
        setupImageView()
        setupHorizontalView()
        configureMoneyInformationView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupCommon() {
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
        let gab: CGFloat = 10

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
        guard let imageView = imageView else { return }
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

fileprivate extension UILabel {
    func attributedText(first: String, second: String, secondFontSize: UIFont.Size) {
        let boldAttribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.designSystem(.mainOrange) ?? UIColor.orange,
            .font: UIFont.gmarketSans(size: .title1, weight: .medium)
        ]
        let attributedText = NSMutableAttributedString(string: "\(first) ", attributes: boldAttribute)

        let attribute: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.gmarketSans(size: secondFontSize, weight: .medium)
        ]
        let secondAttributedText = NSAttributedString(string: second, attributes: attribute)
        attributedText.append(secondAttributedText)

        self.attributedText = attributedText
    }
}
