//
//  ChartInformationCell.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/02.
//

import UIKit

final class ChartInformationCell: UICollectionViewCell {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let amountLabel: UILabel = {
        let label = GmarketSansLabel(
            alignment: .left,
            size: .callout,
            weight: .bold
        )
        return label
    }()

    private let titleLabel: UILabel = {
        let label = GmarketSansLabel(
            alignment: .left,
            size: .callout,
            weight: .bold
        )
        return label
    }()

    private let winResultLabel = GmarketSansLabel(
        alignment: .right,
        size: .callout,
        weight: .medium
    )

    private let resultLabel = GmarketSansLabel(
        alignment: .right,
        size: .callout,
        weight: .medium
    )

    var chartImformationComponents: ChartInformationComponents?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupChartInformationCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        winResultLabel.attributedText = nil
        resultLabel.text = nil
    }

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)

        guard let component = chartImformationComponents else { return }

        imageView.image = component.image
        amountLabel.text = "\(component.amount) 원"
        titleLabel.text = component.type.rawValue

        switch component.type {
        case .win:
            guard let percent = component.result.percent else { return }
            let attributedString = setWinResultLabel(result: component.result.result, percent: percent)
            winResultLabel.attributedText = attributedString
        default:
            setResultLabel(result: component.result.result)
        }
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
        let amountStackView: UIStackView = {
            let stackView = UIStackView()
            stackView.addArrangedSubviews([titleLabel, winResultLabel, resultLabel])
            stackView.distribution = .fillProportionally
            return stackView
        }()

        let informationStackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [amountStackView, amountLabel])
            stackView.distribution = .fillProportionally
            stackView.axis = .vertical
            return stackView
        }()

        let stackView: UIStackView = {
            let stackView = UIStackView(arrangedSubviews: [imageView, informationStackView])
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.spacing = 15
            return stackView
        }()

        return stackView
    }

    private func setWinResultLabel(result: Bool, percent: Int) -> NSMutableAttributedString {
        let convertedPercent = percent.convertToDecimalWithPercent()
        let attributedString = NSMutableAttributedString(string: convertedPercent)

        var percentType: ChartInformationComponents.ChartInformationPercentType
        switch result {
        case true:
            percentType = percent == 0 ? .zero : .plus
        case false:
            percentType = .minus
        }

        let signAttachment = NSTextAttachment()
        signAttachment.image = UIImage(systemName: percentType.systemName)?.withTintColor(percentType.color)
        attributedString.addAttributes([.foregroundColor: percentType.color], range: .init(location: 0, length: attributedString.length))
        attributedString.append(NSAttributedString(attachment: signAttachment))

        return attributedString
    }

    private func setResultLabel(result: Bool) {
        var resultType: ChartInformationComponents.ChartInformationResultType
        resultType = result ? .success : .fail

        resultLabel.text = resultType.rawValue
        resultLabel.textColor = resultType.color
    }
}
