//
//  GmarketSansLabel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/27.
//

import UIKit

class GmarketSansLabel: UILabel {

    init(text: String) {
        super.init(frame: .zero)

        configureGmarketSansLabel(text: text)
    }

    convenience init(text: String, color: UIColor, alignment: NSTextAlignment) {
        self.init(text: text)

        textColor = color
        textAlignment = alignment
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureGmarketSansLabel(text: String) {
        self.text = text
        font = .gmarketSans(size: .callout, weight: .bold)
    }
}
