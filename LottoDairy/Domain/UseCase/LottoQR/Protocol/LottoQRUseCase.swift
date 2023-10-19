//
//  LottoQRUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 10/19/23.
//

import Foundation

protocol LottoQRUseCase {
    func validateLottoURL(_ url: String) -> Bool
}
