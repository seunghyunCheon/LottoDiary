//
//  DoubleLabelStackView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/28.
//

import UIKit

final class DoubleLabelView: UIStackView {

    private var firstLabel = UILabel()
    private var secondLabel = UILabel()
    private var imageView: UIImageView?

    private var imageViewSize: CGFloat?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard imageView != nil else { return }
        self.imageViewSize = self.frame.width * 0.106
        configureHorizontalView()
        configureMoneyInformationView()
    }

    convenience init(month: String, percent: String) {
        self.init(frame: .zero)

        firstLabel.attributedText(first: "\(month)월", second: "동안", secondFontSize: .callout)
        secondLabel.attributedText(first: "목표치의 \(percent)%", second: "를 사용하셨습니다.", secondFontSize: .callout)

        firstLabel.textAlignment = .left
        secondLabel.textAlignment = .left
        configureVerticalStackView()
    }

    convenience init(won: String, riceSoup: String) {
        self.init(frame: .zero)

        firstLabel.attributedText(first: "\(won)원", second: "으로", secondFontSize: .title3)
        secondLabel.attributedText(first: "국밥 \(riceSoup) 그릇", second: "먹기 가능", secondFontSize: .title3)

        firstLabel.textAlignment = .center
        secondLabel.textAlignment = .center
        configureVerticalStackView()
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
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureVerticalStackView() {
        self.addArrangedSubviews([firstLabel, secondLabel])

        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = 10
    }

    private func configureHorizontalView() {
        guard let imageView = imageView else { return }
        self.addArrangedSubviews([imageView, firstLabel, secondLabel])

        self.axis = .horizontal
        self.distribution = .fillProportionally
        self.spacing = 5
    }

    private func configureMoneyInformationView() {
        guard let imageView = imageView, let imageViewSize = imageViewSize else { return }
        imageView.heightAnchor.constraint(equalToConstant: imageViewSize).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageViewSize / 2
        imageView.backgroundColor = .blue

        let firstLabelWidth: CGFloat = self.frame.width * 0.23
        firstLabel.widthAnchor.constraint(equalToConstant: firstLabelWidth).isActive = true
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
