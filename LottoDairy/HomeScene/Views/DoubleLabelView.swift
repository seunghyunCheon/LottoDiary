//
//  DoubleLabelStackView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/28.
//

import UIKit

final class DoubleLabelView: UIStackView {

    enum LabelType {
        case percent
        case riceSoup
    }

    private var firstLabel = UILabel()
    private var secondLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(type: LabelType) {
        self.init(frame: .zero)

        configureVerticalStackView(spacing: 10)

        switch type {
        case .percent:
            firstLabel.textAlignment = .left
            secondLabel.textAlignment = .left
        case .riceSoup:
            firstLabel.textAlignment = .center
            secondLabel.textAlignment = .center
        }
    }

    convenience init(type: AmountType) {
        self.init(frame: .zero)

        self.firstLabel = GmarketSansLabel(text: type.rawValue,
                                           alignment: .left,
                                           size: .subheadLine,
                                           weight: .light)
        self.secondLabel = GmarketSansLabel(alignment: .left,
                                            size: .title3,
                                            weight: .medium)
        configureVerticalStackView(spacing: 5)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateWonAmount(_ won: Int?) {
        self.secondLabel.text = won == nil ? "0" : won?.convertToDecimal()
    }

    func configureExplanationLabel(month: Int) {
        firstLabel.attributedText(first: "\(month)월", second: "동안", secondFontSize: .callout)
    }


    func configureExplanationLabel(percent: Int) {
        secondLabel.attributedText(first: "목표치의 \(percent)%", second: "를 사용하셨습니다.", secondFontSize: .callout)
    }

    func configureRiceSoupLabel(won: Int?) {
        firstLabel.attributedText(first: "\(won ?? .zero)원", second: "으로", secondFontSize: .title3)
    }

    func configureRiceSoupLabel(riceSoup: Int) {
        secondLabel.attributedText(first: "국밥 \(riceSoup) 그릇", second: "먹기 가능", secondFontSize: .title3)
    }

    private func configureVerticalStackView(spacing: CGFloat) {
        self.addArrangedSubviews([firstLabel, secondLabel])

        self.axis = .vertical
        self.distribution = .fillProportionally
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
