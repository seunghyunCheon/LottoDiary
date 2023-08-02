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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(month: String, percent: String) {
        self.init(frame: .zero)

        firstLabel.attributedText(first: "\(month)월", second: "동안", secondFontSize: .callout)
        secondLabel.attributedText(first: "목표치의 \(percent)%", second: "를 사용하셨습니다.", secondFontSize: .callout)

        firstLabel.textAlignment = .left
        secondLabel.textAlignment = .left
        configureVerticalStackView(spacing: 10)
    }

    convenience init(won: String, riceSoup: String) {
        self.init(frame: .zero)

        firstLabel.attributedText(first: "\(won)원", second: "으로", secondFontSize: .title3)
        secondLabel.attributedText(first: "국밥 \(riceSoup) 그릇", second: "먹기 가능", secondFontSize: .title3)

        firstLabel.textAlignment = .center
        secondLabel.textAlignment = .center
        configureVerticalStackView(spacing: 10)
    }

    convenience init(title: String, won: String) {
        self.init(frame: .zero)

        self.firstLabel = GmarketSansLabel(text: title,
                                           alignment: .left,
                                           size: .subheadLine,
                                           weight: .light)
        self.secondLabel = GmarketSansLabel(text: won,
                                            alignment: .left,
                                            size: .title3,
                                            weight: .medium)
        configureVerticalStackView(spacing: 5)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureVerticalStackView(spacing: CGFloat) {
        self.addArrangedSubviews([firstLabel, secondLabel])

        self.axis = .vertical
        self.distribution = .fillEqually
        self.spacing = spacing
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
