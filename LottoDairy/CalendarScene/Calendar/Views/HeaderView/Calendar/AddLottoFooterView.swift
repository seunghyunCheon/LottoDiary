//
//  AddLottoFooterView.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/14.
//

import UIKit

final class AddLottoFooterView: UICollectionReusableView {
    
    static var elementKind: String { UICollectionView.elementKindSectionFooter }
    
    private let plusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let footerLabel: UILabel = {
        let label = GmarketSansLabel(text: "새로운 로또 추가", size: .body, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        self.addSubview(footerLabel)
        NSLayoutConstraint.activate([
            footerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            footerLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
        plusImageView.image = UIImage(named: "add")
        self.addSubview(plusImageView)
        NSLayoutConstraint.activate([
            plusImageView.widthAnchor.constraint(equalToConstant: 20),
            plusImageView.heightAnchor.constraint(equalToConstant: 20),
            plusImageView.centerYAnchor.constraint(equalTo: self.footerLabel.centerYAnchor),
            plusImageView.trailingAnchor.constraint(equalTo: self.footerLabel.leadingAnchor, constant: -10)
        ])
    }
}
