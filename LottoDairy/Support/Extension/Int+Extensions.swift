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

    static let lottoRange: Range<Int> = 1..<46

    static func makeRandomIntArray(count: Int) -> [Int] {
        var returnArray: [Int] = []
        for _ in 0..<count {
            returnArray.append(Int.random(in: lottoRange))
        }

        let sortedRandomReturnArray = returnArray.sorted()

        return sortedRandomReturnArray
    }
}
