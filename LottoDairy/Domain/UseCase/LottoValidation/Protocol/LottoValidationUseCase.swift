//
//  LottoValidationUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Combine

protocol LottoValidationUseCase {
    func fetchLottosWithoutWinningAmount() -> AnyPublisher<[Lotto], Error>
    func fetchLottoResult(_ roundNumber: Int) -> AnyPublisher<[[Int]]?, Error>
    func updateWinningAmount(lotto: Lotto, amount: Int)
}
