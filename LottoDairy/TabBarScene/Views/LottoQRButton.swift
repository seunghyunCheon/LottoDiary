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

        configureLottoQRButton()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var textTransformer: UIConfigurationTextAttributesTransformer {
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.gmarketSans(size: .caption, weight: .bold)
            return outgoing
        }
        return transformer
    }

    private var qrImage: UIImage? {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: TabBarComponents.LottoQR.systemName, withConfiguration: imageConfiguration)
        return image
    }

    private func configureLottoQRButton() {
        backgroundColor = .designSystem(.mainBlue)

        var configuration = UIButton.Configuration.plain()
        configuration.title = TabBarComponents.LottoQR.title
        configuration.titleTextAttributesTransformer = textTransformer
        configuration.image = qrImage
        configuration.imagePadding = 7
        configuration.imagePlacement = .top

        self.configuration = configuration
    }
}
