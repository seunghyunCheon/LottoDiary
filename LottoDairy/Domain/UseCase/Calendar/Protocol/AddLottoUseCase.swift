//
//  AddLottoUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import Combine

protocol AddLottoUseCase {
    var lottoType: LottoType { get set }
    var purchaseAmount: CurrentValueSubject<Int?, Never> { get set }
    var winningAmount: CurrentValueSubject<Int?, Never> { get set }
    func setLottoType(_ type: LottoType)
    func setPurchaseAmount(_ text: String)
    func setWinningAmount(_ text: String)
    func addLotto() -> AnyPublisher<Lotto, Error>
}
