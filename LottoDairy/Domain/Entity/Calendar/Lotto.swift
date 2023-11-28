//
//  Lotto.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import Foundation

final class Lotto {
    let id: UUID
    let date: Date
    let type: LottoType
    let purchaseAmount: Int
    let winningAmount: Int
    let roundNumber: Int
    var lottoNumbers: [[Int]] = []
    
    init(
        id: UUID,
        date: Date,
        type: LottoType,
        purchaseAmount: Int,
        winningAmount: Int,
        lottoNumbers: [[Int]],
        roundNumber: Int = 0
    ) {
        self.id = id
        self.type = type
        self.purchaseAmount = purchaseAmount
        self.winningAmount = winningAmount
        self.lottoNumbers = lottoNumbers
        self.roundNumber = roundNumber
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dates = dateFormatter.date(from: dateFormatter.string(from: date))
        print(dates)
        self.date = dates ?? Date()
    }
    
    convenience init(
        type: LottoType,
        date: Date,
        purchaseAmount: Int,
        winningAmount: Int
    ) {
        self.init(id: UUID(), date: date, type: type, purchaseAmount: purchaseAmount, winningAmount: winningAmount, lottoNumbers: [])
    }
    
    convenience init(
        date: Date,
        purchaseAmount: Int,
        winningAmount: Int,
        lottoNumbers: [[Int]]
    ) {
        self.init(id: UUID(), date: date, type: .lotto, purchaseAmount: purchaseAmount, winningAmount: winningAmount, lottoNumbers: lottoNumbers)
    }
    
    // QR Initializer
    convenience init(
        purchaseAmount: Int,
        winningAmount: Int,
        lottoNumbers: [[Int]],
        roundNumber: Int
    ) {
        self.init(id: UUID(), date: Date(), type: .lotto, purchaseAmount: purchaseAmount, winningAmount: winningAmount, lottoNumbers: lottoNumbers, roundNumber: roundNumber)
    }
}

extension Lotto: Hashable {
    static func == (lhs: Lotto, rhs: Lotto) -> Bool {
        return lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.purchaseAmount == rhs.purchaseAmount &&
        lhs.winningAmount == rhs.winningAmount &&
        lhs.lottoNumbers == rhs.lottoNumbers
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
        hasher.combine(purchaseAmount)
        hasher.combine(winningAmount)
        hasher.combine(lottoNumbers)
    }
}
