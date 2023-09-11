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

// 추후 색상 설정해야 함 color: textColor,
    private let winResultLabel = GmarketSansLabel(
        alignment: .right,
        size: .caption,
        weight: .medium
    )

    // 추후 글자와 색상 설정
    private let resultLabel = GmarketSansLabel(
        alignment: .right,
        size: .caption,
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
            guard let result = component.result, let percent = result.percent else { return }
            let convertedPercent = percent.convertToDecimalWithPercent()
            let attributedString = setAttributedString(convertedPercent, result: result.result, percent: percent)
            winResultLabel.attributedText = attributedString
        default:
            guard let result = component.result?.result else { return }
            if result == true {
                resultLabel.text = "달성 완료!"
            } else {
                resultLabel.text = "달성 실패!"
            }
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

    private func setAttributedString(_ string: String, result: Bool, percent: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: string)
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

        return attributedString
    }
}
