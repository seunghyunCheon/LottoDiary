//
//  LottoRepository.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/16.
//

import Combine
import Foundation

protocol LottoRepository {
    func fetchLottosWithoutWinningAmount() -> AnyPublisher<[Lotto], Error>
    func fetchLottos(with startDate: Date, and endDate: Date) -> AnyPublisher<[Lotto], Error>
    func fetchAllOfYear() -> AnyPublisher<[Int], Error>
    func saveLotto(_ lotto: Lotto) -> AnyPublisher<Lotto, Error>
    func updateWinningAmount(_ id: String, amount: Int) -> AnyPublisher<Lotto, Error>
}
