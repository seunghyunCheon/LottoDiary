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
    @discardableResult
    func crawlLottoResult(id: String?, url: String) -> AnyPublisher<Lotto, Error>
}
