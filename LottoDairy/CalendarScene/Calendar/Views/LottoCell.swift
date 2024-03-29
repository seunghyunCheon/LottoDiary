//
//  LottoCell.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/12.
//

import UIKit

final class LottoCell: UICollectionViewCell {
    
    private var lottoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = GmarketSansLabel(text: "로또", size: .body, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var purchaseLabel: UILabel = {
        let label = GmarketSansLabel(text: "구매 금액", size: .middleCaption, weight: .medium)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.textAlignment = .center
        return label
    }()
    
    private var purchaseAmountLabel: UILabel = {
        let label = GmarketSansLabel(size: .subheadLine, weight: .bold)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var purchaseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private var winningLabel: UILabel = {
        let label = GmarketSansLabel(text: "당첨 금액", size: .middleCaption, weight: .medium)
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.textAlignment = .center
        return label
    }()
    
    private var winningAmountLabel: UILabel = {
        let label = GmarketSansLabel(size: .subheadLine, weight: .bold)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private var winningStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 15.0
        self.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        self.backgroundColor = .clear
        self.lottoImageView.image = nil
        self.titleLabel.text = nil
        self.purchaseAmountLabel.text = nil
        self.winningAmountLabel.text = nil
    }

    func configure(with lotto: Lotto) {
        lottoImageView.image = UIImage(named: lotto.type.imageName)
        titleLabel.text = lotto.type.rawValue
        purchaseAmountLabel.text = String(lotto.purchaseAmount.convertToDecimal()) + " 원"
        if lotto.winningAmount == -1 {
            winningAmountLabel.text = "미지정"
        } else {
            winningAmountLabel.text = String(lotto.winningAmount.convertToDecimal()) + " 원"
        }

        switch lotto.type {
        case .lotto:
            self.backgroundColor = .designSystem(.mainOrange)
        case .spitto:
            self.backgroundColor = .designSystem(.mainBlue)
        }
    }
}

// MARK: Layout
extension LottoCell {
    
    private func setupLayout() {
        self.addSubview(lottoImageView)
        NSLayoutConstraint.activate([
            lottoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            lottoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lottoImageView.widthAnchor.constraint(equalToConstant: 25),
            lottoImageView.heightAnchor.constraint(equalToConstant: 25),
        ])

        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.lottoImageView.trailingAnchor, constant: 5),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])


        self.addSubview(self.purchaseStackView)
        self.purchaseStackView.addArrangedSubview(purchaseLabel)
        self.purchaseStackView.addArrangedSubview(purchaseAmountLabel)
        NSLayoutConstraint.activate([
            purchaseStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
        ])

        self.addSubview(self.winningStackView)
        self.winningStackView.addArrangedSubview(winningLabel)
        self.winningStackView.addArrangedSubview(winningAmountLabel)
        NSLayoutConstraint.activate([
            winningStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
        ])

        let informationStackView = UIStackView()
        informationStackView.axis = .vertical
        informationStackView.alignment = .center
        informationStackView.distribution = .fillEqually
        informationStackView.translatesAutoresizingMaskIntoConstraints = false
        informationStackView.spacing = 15
        self.addSubview(informationStackView)
        informationStackView.addArrangedSubview(self.purchaseStackView)
        informationStackView.addArrangedSubview(self.winningStackView)
        NSLayoutConstraint.activate([
            informationStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            informationStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            informationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
        ])
    }
}
