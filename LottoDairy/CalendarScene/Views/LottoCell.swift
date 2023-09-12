//
//  LottoCell.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/12.
//

import UIKit

enum LottoType {
    case lotto
    case spitto
}

final class LottoCell: UITableViewCell {
    
    static let identifer = "LottoCell"
    
    var lottoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = GmarketSansLabel(text: "로또", size: .body, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var purchaseLabel: UILabel = {
        let label = GmarketSansLabel(text: "구매 금액", size: .callout, weight: .light)
        return label
    }()
    
    var purchaseAmountLabel: UILabel = {
        let label = GmarketSansLabel(text: "30,000원", size: .body, weight: .bold)
        return label
    }()
    
    var purchaseStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    var winningLabel: UILabel = {
        let label = GmarketSansLabel(text: "당첨 금액", size: .callout, weight: .light)
        return label
    }()
    
    var winningAmountLabel: UILabel = {
        let label = GmarketSansLabel(text: "3,000원", size: .body, weight: .bold)
        return label
    }()
    
    var winningStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(lottoImageView)
        NSLayoutConstraint.activate([
            lottoImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            lottoImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            lottoImageView.widthAnchor.constraint(equalToConstant: 10),
            lottoImageView.heightAnchor.constraint(equalToConstant: 10),
        ])
        
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.lottoImageView.trailingAnchor, constant: 2),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        
        
        self.addSubview(self.purchaseStackView)
        self.purchaseStackView.addArrangedSubview(purchaseLabel)
        self.purchaseStackView.addArrangedSubview(purchaseAmountLabel)
        NSLayoutConstraint.activate([
            purchaseStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2),
        ])
        
        self.addSubview(self.winningStackView)
        self.winningStackView.addArrangedSubview(winningLabel)
        self.winningStackView.addArrangedSubview(winningAmountLabel)
        NSLayoutConstraint.activate([
            winningStackView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2),
        ])
        
        let informationStackView = UIStackView()
        informationStackView.axis = .vertical
        informationStackView.alignment = .center
        self.addSubview(informationStackView)
        informationStackView.addArrangedSubview(self.purchaseStackView)
        informationStackView.addArrangedSubview(self.winningStackView)
        NSLayoutConstraint.activate([
            informationStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            informationStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    func configure() {
        lottoImageView.image = UIImage(named: "lotto")
    }
}

