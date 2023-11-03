//
//  LottoValidationController.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Combine
import Foundation

final class LottoValidationController {
    
    private let lottoValidationUseCase: LottoValidationUseCase

    private var roundNumberSet: [Int: [[Int]]] = [:]

    private var cancellables = Set<AnyCancellable>()

    init(lottoValidationUseCase: LottoValidationUseCase) {
        self.lottoValidationUseCase = lottoValidationUseCase
    }
}
