//
//  DefaultLottoValidationUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Combine

final class DefaultLottoValidationUseCase: LottoValidationUseCase {
    
    private let lottoRepository: LottoRepository

    init(lottoRepository: LottoRepository) {
        self.lottoRepository = lottoRepository
    }
    
    // 로또 데이터 조회해서 당첨 금액 없는 데이터 조회
    func fetchLottosWithoutWinningAmount() -> AnyPublisher<[Lotto], Error> {

        #if DEBUG
        print("[ℹ️][LottoValidationUseCase.swift] -> 당첨 금액 없는 로또 데이터 조회")
        #endif

        return lottoRepository.fetchLottosWithoutWinningAmount()
    }

    // 회차번호가 결과가 나왔는지 네트워킹
    // 지금은 임시 데이터 return
    func fetchLottoResult(_ roundNumber: Int) -> AnyPublisher<[[Int]]?, Error> {
        // 회차 번호 안나왔을 경우 nil 반환
        let publisher = [[01, 23, 24, 16, 43, 35]]
            .publisher
            .collect()
            .map { numbers in
                return numbers.isEmpty ? nil : numbers
            }
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
        return publisher
    }

    // 로또 데이터 당첨 금액 업데이트
    func updateWinningAmount(lotto: Lotto, amount: Int) {
        lottoRepository.updateWinningAmount(lotto, amount: amount)
    }
}
