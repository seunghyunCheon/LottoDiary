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
    let url: String
//    let roundNumber: Int
//    var lottoNumbers: [[Int]] = []
    
    init(
        id: UUID,
        date: Date,
        type: LottoType,
        purchaseAmount: Int,
        winningAmount: Int,
        url: String
//        lottoNumbers: [[Int]],
//        roundNumber: Int = 0
    ) {
        self.id = id
        self.type = type
        self.purchaseAmount = purchaseAmount
        self.winningAmount = winningAmount
//        self.lottoNumbers = lottoNumbers
//        self.roundNumber = roundNumber
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let dates = dateFormatter.date(from: dateFormatter.string(from: date))
        self.date = dates ?? Date()
        self.url = url
    }
    
    convenience init(
        type: LottoType = .lotto,
        date: Date,
        purchaseAmount: Int,
        winningAmount: Int,
        url: String
    ) {
        self.init(
            id: UUID(),
            date: date,
            type: type,
            purchaseAmount: purchaseAmount, 
            winningAmount: winningAmount,
            url: url
        )
    }
    
    // QR Initializer
    convenience init(
        purchaseAmount: Int,
        winningAmount: Int,
        url: String
    ) {
        self.init(
            id: UUID(),
            date: Date(),
            type: .lotto,
            purchaseAmount: purchaseAmount,
            winningAmount: winningAmount,
            url: url
        )
    }
}

extension Lotto: Hashable {
    static func == (lhs: Lotto, rhs: Lotto) -> Bool {
        return lhs.id == rhs.id &&
        lhs.type == rhs.type &&
        lhs.purchaseAmount == rhs.purchaseAmount &&
        lhs.winningAmount == rhs.winningAmount
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
        hasher.combine(purchaseAmount)
        hasher.combine(winningAmount)
    }
}
