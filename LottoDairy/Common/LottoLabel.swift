//
//  LottoLabel.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/27.
//

import UIKit

final class LottoLabel: UILabel {
    
    init(text: String?, font: UIFont, textColor: UIColor = .white) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
        self.textColor = textColor
        self.adjustsFontForContentSizeCategory = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
