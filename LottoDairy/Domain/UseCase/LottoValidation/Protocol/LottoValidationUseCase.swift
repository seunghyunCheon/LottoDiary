//
//  LottoResultValidationUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Combine

protocol LottoResultValidationUseCase {
    func fetchLottosWithoutWinningAmount() -> AnyPublisher<[Lotto], Error>
//    func fetchLottoResult(_ roundNumber: Int) -> AnyPublisher<[[Int]]?, Error>
    func valid(_ url: String) -> Bool
    func crawlLottoResult(_ url: String) -> AnyPublisher<Lotto, Error>
    func updateWinningAmount(lotto: Lotto, amount: Int)
}
