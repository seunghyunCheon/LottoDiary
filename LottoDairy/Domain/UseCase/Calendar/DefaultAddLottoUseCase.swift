//
//  DefaultAddLottoUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import Combine

final class DefaultAddLottoUseCase: AddLottoUseCase {
    
    var lottoType: LottoType = .lotto
    var purchaseAmount = CurrentValueSubject<Int?, Never>(nil)
    var winningAmount = CurrentValueSubject<Int?, Never>(nil)
    
    func setLottoType(_ type: String) {
        self.lottoType = LottoType(rawValue: type) ?? .lotto
    }
    
    func setPurchaseAmount(_ text: String) {
        self.purchaseAmount.value = text.convertDecimalToInt()
    }
    
    func setWinningAmount(_ text: String) {
        self.winningAmount.value = text.convertDecimalToInt()
    }
    
    func addLotto() -> Lotto {
        let newLotto = Lotto(
            type: self.lottoType,
            purchaseAmount: self.purchaseAmount.value ?? 0,
            winningAmount: self.winningAmount.value ?? 0
        )
        
        return newLotto
    }
}
