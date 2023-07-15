//
//  LottoQRButton.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/15.
//

import UIKit

final class LottoQRButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureTextAttribute()
        configureImage()
        configureLottoQRButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLottoQRButton() {
        self.backgroundColor = .designSystem(.mainBlue)
        self.alignTextBelow(spacing: 7)
    }

    private func configureTextAttribute() {
        let attribute: [NSAttributedString.Key: Any] = [
            .font: UIFont.gmarketSans(size: .caption, weight: .bold),
            .foregroundColor: UIColor.white
        ]
        let attributedString = NSAttributedString(string: TabBarComponents.LottoQR.title, attributes: attribute)

        setAttributedTitle(attributedString, for: .normal)
    }

    private func configureImage() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: TabBarComponents.LottoQR.systemName, withConfiguration: imageConfiguration)
        self.setImage(image, for: .normal)
    }
}
