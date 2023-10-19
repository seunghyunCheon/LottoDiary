//
//  DefaultLottoQRUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 10/19/23.
//

import Combine

final class DefaultLottoQRUseCase: LottoQRUseCase {

    func validateLottoURL(_ url: String) -> Bool {
        return url.contains(LottoAPI.baseURL)
    }
}
