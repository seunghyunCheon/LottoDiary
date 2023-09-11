//
//  ChartInformationCell.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/02.
//

import UIKit

final class ChartInformationCell: UICollectionViewCell {

    var chartImformationComponents: ChartInformationComponents?

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)

        setupChartInformationCell()
    }

    func configure(with components: ChartInformationComponents) {
        self.chartImformationComponents = components
    }

    private func setupChartInformationCell() {
        let totalStackView = makeTotalStackView()
        self.addSubview(totalStackView)

        NSLayoutConstraint.activate([
            totalStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            totalStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            totalStackView.topAnchor.constraint(equalTo: self.topAnchor),
            totalStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func makeTotalStackView() -> UIStackView {
        let imageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = chartImformationComponents?.image
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            return imageView
        }()
        let informationStackView = makeInformationStackView()

        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [imageView, informationStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 15
            return stackView
        }()

        return stackView
    }

    private func makeInformationStackView() -> UIStackView {
        let amountStackView = makeAmountStackView()

        let amountLabel: UILabel = {
            let label = GmarketSansLabel(
                text: "\(chartImformationComponents?.amount ?? "") 원",
                alignment: .left,
                size: .callout,
                weight: .bold
            )
            return label
        }()

        let InformationStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [amountStackView, amountLabel])
            stackView.distribution = .fillProportionally
            stackView.axis = .vertical
            return stackView
        }()

        return InformationStackView
    }

    private func makeResultLabel(_ result: Bool) -> UILabel {
        switch result {
        case true:
            let label = GmarketSansLabel(
                text: "달성 완료!",
                color: .designSystem(.mainGreen) ?? .green,
                alignment: .right,
                size: .caption,
                weight: .medium
            )
            return label
        case false:
            let label = GmarketSansLabel(
                text: "달성 실패!",
                color: .designSystem(.mainBlue) ?? .systemBlue,
                alignment: .right,
                size: .caption,
                weight: .medium
            )
            return label
        }
    }

    private func makeWinResultLabel(result: Bool, percent: Int) -> UILabel {
        let convertedPercent = percent.convertToDecimalWithPercent()
        let attributedString = NSMutableAttributedString(string: convertedPercent)
        let signAttachment = NSTextAttachment()

        var textColor: UIColor
        var imageName: String

        switch result {
        case true:
            if percent == 0 {
                imageName = "minus"
                textColor = .designSystem(.mainGreen) ?? .green
            } else {
                imageName = "arrowtriangle.up.fill"
                textColor = .designSystem(.mainOrange) ?? .orange
            }
        case false:
            imageName = "arrowtriangle.down.fill"
            textColor = .designSystem(.mainBlue) ?? .systemBlue
        }

        signAttachment.image = UIImage(systemName: imageName)?.withTintColor(textColor)
        attributedString.append(NSAttributedString(attachment: signAttachment))

        let label = GmarketSansLabel(
            attributedText: attributedString,
            color: textColor,
            alignment: .right,
            size: .caption,
            weight: .medium
        )

        return label
    }


    private func makeAmountStackView() -> UIStackView {
        let titleLabel: UILabel = {
            let label = GmarketSansLabel(
                text: chartImformationComponents?.type.rawValue ?? "",
                alignment: .left,
                size: .callout,
                weight: .bold
            )
            return label
        }()


        let resultLabel: UILabel = {
            switch chartImformationComponents?.type {
            case .win:
                guard let result = chartImformationComponents?.result, let percent = result.percent else { return UILabel() }
                let label = makeWinResultLabel(result: result.result, percent: percent)
                return label
            default:
                let label = makeResultLabel(chartImformationComponents?.result?.result ?? true)
                return label
            }
        }()

        let amountStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel, resultLabel])
            stackView.distribution = .fillProportionally
            return stackView
        }()

        return amountStackView
    }
}
