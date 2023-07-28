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
         size: Size,
         weight: CustomWeight) {
        super.init(frame: .zero)

        self.text = text
        font = .gmarketSans(size: size, weight: weight)
        textColor = color
        textAlignment = alignment
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
