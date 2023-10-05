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
    var isResultAnnounced: Bool = true
    
    init(
        id: UUID,
        date: Date,
        type: LottoType,
        purchaseAmount: Int,
        winningAmount: Int,
        lottoNumbers: [[Int]],
        isResultAnnounced: Bool,
        roundNumber: Int = 0
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.purchaseAmount = purchaseAmount
        self.winningAmount = winningAmount
        self.lottoNumbers = lottoNumbers
        self.isResultAnnounced = isResultAnnounced
        self.roundNumber = roundNumber
    }
    
    convenience init(type: LottoType, date: Date, purchaseAmount: Int, winningAmount: Int) {
        self.init(id: UUID(), date: date, type: type, purchaseAmount: purchaseAmount, winningAmount: winningAmount, lottoNumbers: [], isResultAnnounced: true)
    }
}

extension Lotto: Hashable {
    static func == (lhs: Lotto, rhs: Lotto) -> Bool {
        return lhs.id == rhs.id && lhs.type == rhs.type && lhs.purchaseAmount == rhs.purchaseAmount && lhs.winningAmount == rhs.winningAmount && lhs.isResultAnnounced == rhs.isResultAnnounced && lhs.lottoNumbers == rhs.lottoNumbers
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(type)
        hasher.combine(purchaseAmount)
        hasher.combine(winningAmount)
        hasher.combine(isResultAnnounced)
        hasher.combine(lottoNumbers)
    }
}
