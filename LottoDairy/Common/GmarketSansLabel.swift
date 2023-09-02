//
//  GmarketSansLabel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/27.
//

import UIKit

class GmarketSansLabel: UILabel {

    init(text: String,
         color: UIColor = .white,
         alignment: NSTextAlignment = .center,
         size: UIFont.Size,
         weight: UIFont.CustomWeight) {
        super.init(frame: .zero)

        self.text = text
        self.font = .gmarketSans(size: size, weight: weight)
        self.adjustsFontForContentSizeCategory = true
        self.textColor = color
        self.textAlignment = alignment
    }

    init(attributedText: NSAttributedString,
         color: UIColor = .white,
         alignment: NSTextAlignment = .center,
         size: UIFont.Size,
         weight: UIFont.CustomWeight) {
        super.init(frame: .zero)

        self.attributedText = attributedText
        self.font = .gmarketSans(size: size, weight: weight)
        self.adjustsFontForContentSizeCategory = true
        self.textColor = color
        self.textAlignment = alignment
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
