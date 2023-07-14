//
//  LottoQRButton.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/15.
//

import UIKit

final class LottoQRButton: UIButton {

    private var buttonConfiguration = UIButton.Configuration.filled()

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
        buttonConfiguration.baseBackgroundColor = .designSystem(.mainBlue)
        self.configuration = buttonConfiguration
    }

    private func configureTextAttribute() {
        var textAttribute = AttributedString(TabBarComponents.LottoQR.title)
        textAttribute.font = .gmarketSans(size: .caption, weight: .bold)

        buttonConfiguration.attributedSubtitle = textAttribute
        buttonConfiguration.titleAlignment = .center
    }

    private func configureImage() {
        let image = UIImage(systemName: TabBarComponents.LottoQR.systemName)
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 20)

        buttonConfiguration.preferredSymbolConfigurationForImage = imageConfiguration
        buttonConfiguration.image = image
        buttonConfiguration.imagePadding = 5
        buttonConfiguration.imagePlacement = .top
    }
}
