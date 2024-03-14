//
//  UIFont+Extensions.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/12.
//

import UIKit

extension UIFont {
    enum Family: String {
        case gmarketSans
    }

    enum CustomWeight: String {
        case light = "Light"
        case medium = "Medium"
        case bold = "Bold"
    }

    enum Size: CGFloat {
        /// 33
        case largeTitle = 33
        /// 27
        case title1 = 27
        /// 21
        case title2 = 21
        /// 19
        case title3 = 19
        /// 16
        case body = 16
        /// 15
        case callout = 15
        /// 14
        case subheadLine = 14
        /// 12
        case middleCaption = 12
        /// 11
        case caption = 11
    }

    private class func stringName(_ family: Family, _ weight: CustomWeight) -> String {
        return "\(family.rawValue)TTF\(weight.rawValue)"
    }
}

// MARK: - Initializers

extension UIFont {
    static func gmarketSans(size: Size, weight: CustomWeight) -> UIFont {
        guard let customFont =  UIFont(name: UIFont.stringName(.gmarketSans, weight), size: size.rawValue) else {
            return UIFont.systemFont(ofSize: size.rawValue)
        }
        
        return UIFontMetrics.default.scaledFont(for: customFont)
    }
}

