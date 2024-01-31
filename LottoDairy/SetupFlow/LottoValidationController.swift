//
//  LottoValidationController.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Combine
import Foundation

protocol LottoValidationFlowProtocol {
    func updateLottosWithNoResult()
}

final class LottoValidationController: LottoValidationFlowProtocol {

    private let lottoResultValidationUseCase: LottoResultValidationUseCase

    private var cancellables = Set<AnyCancellable>()

    init(lottoResultValidationUseCase: LottoResultValidationUseCase) {
        self.lottoResultValidationUseCase = lottoResultValidationUseCase
    }

    func updateLottosWithNoResult() {
        // 1. 당첨 결과가 없는 로또 fetch
        lottoResultValidationUseCase.fetchLottosWithoutWinningAmount()
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { lottos in
                lottos.forEach { lotto in
//                    return self.fetchLottoResult(lotto)
//                        .sink { completion in
//                            if case .failure(let error) = completion {
//                                print(error.localizedDescription)
//                            }
//                        } receiveValue: { result in
//
//                        }
//                        .store(in: &self.cancellables)
                }
            }
            .store(in: &cancellables)
    }
}
