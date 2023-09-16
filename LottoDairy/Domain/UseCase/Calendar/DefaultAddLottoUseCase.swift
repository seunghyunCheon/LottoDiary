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
    
    func setLottoType(_ type: LottoType) {
        self.lottoType = type
    }
    
    func setPurchaseAmount(_ text: String) {
        self.purchaseAmount.value = text.convertDecimalToInt()
    }
    
    func setWinningAmount(_ text: String) {
        self.winningAmount.value = text.convertDecimalToInt()
    }
    
    func addLotto() -> AnyPublisher<Lotto, Error> {
        let newLotto = Lotto(
            type: self.lottoType,
            purchaseAmount: self.purchaseAmount.value ?? 0,
            winningAmount: self.winningAmount.value ?? 0
        )
        return Just(Lotto(type: .lotto, purchaseAmount: 10, winningAmount: 10)).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
}
