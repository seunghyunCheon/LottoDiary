//
//  Int+Extensions.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Foundation

extension Int {
    func convertToDecimal() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
            
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }

    func convertToDecimalWithPercent() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal

        return (numberFormatter.string(from: NSNumber(value: self)) ?? "") + "%"
    }
}
