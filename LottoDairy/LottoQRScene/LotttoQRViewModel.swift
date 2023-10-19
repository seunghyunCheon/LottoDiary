//
//  LotttoQRViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/10/10.
//

import Foundation
import Combine

enum LottoQRState {
    case invalid
    case canNotAvailable
    case valid
}

final class LottoQRViewModel {
    
    private let lottoQRUseCase: LottoQRUseCase

    init(lottoQRUseCase: LottoQRUseCase) {
        self.lottoQRUseCase = lottoQRUseCase
    }

}
