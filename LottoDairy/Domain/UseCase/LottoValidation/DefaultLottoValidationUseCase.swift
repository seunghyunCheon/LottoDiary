//
//  DefaultLottoValidationUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Foundation

final class DefaultLottoValidationUseCase: LottoValidationUseCase {
    
    private let lottoRepository: LottoRepository

    init(lottoRepository: LottoRepository) {
        self.lottoRepository = lottoRepository
    }
    
    // 로또 데이터 조회해서 당첨 금액 없는 데이터 조회,
    //
    func fetchLottosWithoutWinningAmount() {
//        lottoRepository.fetchLottos()
    }
}
