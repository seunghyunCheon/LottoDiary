//
//  ChartInformationCell.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/02.
//

import UIKit

struct ChartInformationComponents: Hashable {
    let image: UIImage
    let type: ChartInformationType
    var amount: String
    // 1, 2 : (달성 여부, nil)
    // 3 : (+/-, 금액)
    var result: (result: Bool, percent: Int?)

    init(image: UIImage, type: ChartInformationType, amount: Int, result: (result: Bool, percent: Int?)) {
        self.image = image
        self.type = type
        self.amount = amount.convertToDecimal()
        self.result = result
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(result.result)
        hasher.combine(result.percent)
    }

    static func == (lhs: ChartInformationComponents, rhs: ChartInformationComponents) -> Bool {
        return lhs.amount == rhs.amount && lhs.result.result == rhs.result.result && lhs.result.percent == rhs.result.percent
    }

    static let mock: [ChartInformationComponents] = {
        return [
            ChartInformationComponents(
                image: .actions,
                type: .goal,
                amount: 3000,
                result: (true, nil)),
            ChartInformationComponents(
                image: .checkmark,
                type: .buy,
                amount: 1000,
                result: (false, nil)),
            ChartInformationComponents(
                image: .remove,
                type: .win,
                amount: 6000,
                result: (true, 200))
        ]
    }()
}

enum ChartInformationType: String {
    case goal = "목표 금액"
    case buy = "구매 금액"
    case win = "당첨 금액"
}

enum ChartInformationSection {
    case main
}

final class ChartInformationCell: UICollectionViewCell {

    var chartImformationComponents: ChartInformationComponents?

//    init() {
//        super.init(frame: .zero)
//
//        setupChartInformationCell()
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

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
            //            imageView.image = chartImformationComponents?.image
            imageView.image = .checkmark
            imageView.backgroundColor = .blue
            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
            return imageView
        }()
        let informationStackView = makeInformationStackView()

        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [imageView, informationStackView])
            stackView.backgroundColor = .purple
//            stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.distribution = .fill
            stackView.alignment = .fill
            stackView.spacing = 15
            return stackView
        }()

        return stackView
    }

    private func makeInformationStackView() -> UIStackView {
        let amountStackView = makeAmountStackView()

        let amountLabel: UILabel = {
            let label = GmarketSansLabel(
                //                text: "\(chartImformationComponents?.amount ?? "") 원",
                text: "3,00000000000000000 원",
                alignment: .left,
                size: .callout,
                weight: .bold
            )
            return label
        }()

        let InformationStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [amountStackView, amountLabel])
            stackView.backgroundColor = .yellow
            stackView.distribution = .fillProportionally
            //            stackView.spacing = 5
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
                //                text: chartImformationComponents?.type.rawValue ?? "",
                text: "목표 금액",
                alignment: .left,
                size: .callout,
                weight: .bold
            )
            return label
        }()

        //        guard let result = chartImformationComponents?.result, let percent = result.percent else { return UIStackView() }

        let resultLabel: UILabel = {
            switch chartImformationComponents?.type {
            case .win:
                //                let label = makeWinResultLabel(result: result.result, percent: percent)
                let label = makeWinResultLabel(result: true, percent: 3000000000000000000)
                return label
            default:
                //                let label = makeResultLabel(result.result)
                let label = makeResultLabel(false)
                return label
            }
        }()

        let amountStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [titleLabel, resultLabel])
            stackView.backgroundColor = .darkGray
            stackView.distribution = .fillProportionally
            return stackView
        }()

        return amountStackView
    }
}
