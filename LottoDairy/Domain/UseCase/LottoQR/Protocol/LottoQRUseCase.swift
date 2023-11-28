//
//  LottoQRUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 10/19/23.
//

import Foundation
import Combine

protocol LottoQRUseCase {
    func validateLottoURL(_ url: String) -> Bool
    func crawlLottoResult(_ url: String) -> AnyPublisher<Lotto, Error>
}
