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

    static func makeRandomLottoNumber() -> [Int] {
        var arrayWithoutBonus: Set<Int> = []
        while arrayWithoutBonus.count != 6 {
            arrayWithoutBonus.insert(Int.random(in: lottoRange))
        }

        var bonus: Int = .random(in: lottoRange)

        while arrayWithoutBonus.contains(bonus) {
            bonus = Int.random(in: lottoRange)
        }

        return arrayWithoutBonus.sorted() + [bonus]
    }
}
