//
//  UIColor+Extensions.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/12.
//

import UIKit

extension UIColor {
    enum Palette: String {
        case mainOrange
        case mainBlue
        case mainGreen
        case mainYellow
        case backgroundBlack
        case grayA09FA7
        case grayD8D8D8
        case gray17181D
        case gray2B2C35
        case gray2D2B35
        case gray3C3C47
        case gray4D4D59
        case gray63626B
        case whiteEAE9EE
        case white
    }
    
    class func designSystem(_ color: Palette) -> UIColor? {
        UIColor(named: color.rawValue)
    }
}
