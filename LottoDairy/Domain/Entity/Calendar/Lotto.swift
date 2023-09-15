//
//  Lotto.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import Foundation

final class Lotto {
    let id: UUID
    let type: LottoType
    let purchaseAmount: Int
    let winningAmount: Int
    var lottoNumbers: [[Int]] = []
    var isResultAnnounced: Bool = true
    
    init(id: UUID, type: LottoType, purchaseAmount: Int, winningAmount: Int, lottoNumbers: [[Int]], isResultAnnounced: Bool) {
        self.id = id
        self.type = type
        self.purchaseAmount = purchaseAmount
        self.winningAmount = winningAmount
        self.lottoNumbers = lottoNumbers
        self.isResultAnnounced = isResultAnnounced
    }
    
    convenience init(type: LottoType, purchaseAmount: Int, winningAmount: Int) {
        self.init(id: UUID(), type: type, purchaseAmount: purchaseAmount, winningAmount: winningAmount, lottoNumbers: [], isResultAnnounced: true)
    }
}
