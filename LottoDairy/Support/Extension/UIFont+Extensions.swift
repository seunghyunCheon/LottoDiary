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
    
    private class func stringName(_ family: Family, _ weight: CustomWeight) -> String {
        return "\(family.rawValue)TTF\(weight.rawValue)"
    }

    enum CustomWeight: String {
        case light = "Light"
        case medium = "Medium"
        case bold = "Bold"
    }

    enum Size: CGFloat {
        case largeTitle = 33
        case title1 = 27, title2 = 21, title3 = 19
        case body = 16
        case callout = 15
        case subheadLine = 14
        case caption = 11
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

