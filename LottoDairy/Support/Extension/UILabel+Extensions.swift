//
//  UILabel+.swift
//  LottoDairy
//
//  Created by Brody on 2023/08/18.
//

import UIKit

extension UILabel {
    
    func asFont(targetString: String, font: UIFont) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttribute(.font, value: font, range: range)
        attributedText = attributedString
    }
    
    func setLineSpacing(spacing: CGFloat) {
            guard let text = text else { return }

            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            style.lineSpacing = spacing
            attributeString.addAttribute(.paragraphStyle,
                                         value: style,
                                         range: NSRange(location: 0, length: attributeString.length))
            attributedText = attributeString
        }
}

