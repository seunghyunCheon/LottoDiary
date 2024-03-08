//
//  LottoValidationController.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Combine
import Foundation

protocol LottoValidationFlowProtocol {
    func fetchLottosWithNoResult()
}

final class LottoValidationController: LottoValidationFlowProtocol {

    private let lottoResultValidationUseCase: LottoResultValidationUseCase

    private var cancellables = Set<AnyCancellable>()

    private var noResultLotto: [Lotto] = []

    init(lottoResultValidationUseCase: LottoResultValidationUseCase) {
        self.lottoResultValidationUseCase = lottoResultValidationUseCase
    }

    // 1. 당첨 결과가 없는 로또 fetch
    func fetchLottosWithNoResult() {
        self.lottoResultValidationUseCase.fetchLottosWithoutWinningAmount()
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { lottos in
                // 당첨 결과 없는 로또를 noResultLotto에 넣기
                self.noResultLotto = lottos

                self.updateLottosWithNoResult()
            }
            .store(in: &cancellables)
    }

    // 2. 당첨 결과 없는 로또를 크롤링 해서 결과 있는지 확인하기
    func updateLottosWithNoResult() {
        for lotto in noResultLotto {
            self.lottoResultValidationUseCase.crawlLottoResult(
                id: lotto.id.uuidString,
                url: lotto.url
            )
        }
    }
}
