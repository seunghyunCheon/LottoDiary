//
//  LottoRepository.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/16.
//

import Combine
import Foundation

protocol LottoRepository {
    func fetchLottos(with startDate: Date, and endDate: Date) -> AnyPublisher<[Lotto], Error>
    func saveLotto(_ lotto: Lotto) -> AnyPublisher<Void, Error>
}
