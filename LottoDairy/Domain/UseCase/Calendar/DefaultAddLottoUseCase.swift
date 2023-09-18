//
//  DefaultAddLottoUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import Combine
import Foundation

enum AddLottoUseCaseError: LocalizedError {
    case failedToCreateLotto
    
    var errorDescription: String? {
        switch self {
        case .failedToCreateLotto:
            return "로또 생성에 실패했습니다."
        }
    }
}

final class DefaultAddLottoUseCase: AddLottoUseCase {
    
    var selectedDate: Date?
    var lottoType: LottoType = .lotto
    var purchaseAmount = CurrentValueSubject<Int?, Never>(nil)
    var winningAmount = CurrentValueSubject<Int?, Never>(nil)
    private let lottoRepository: LottoRepository
    
    init(lottoRepository: LottoRepository) {
        self.lottoRepository = lottoRepository
    }
    
    func setLottoType(_ type: LottoType) {
        self.lottoType = type
    }
    
    func setPurchaseAmount(_ text: String) {
        self.purchaseAmount.value = text.convertDecimalToInt()
    }
    
    func setWinningAmount(_ text: String) {
        self.winningAmount.value = text.convertDecimalToInt()
    }
    
    func addLotto() -> AnyPublisher<Lotto, Error> {
        guard let selectedDate else {
            return Fail(error: AddLottoUseCaseError.failedToCreateLotto).eraseToAnyPublisher()
        }
        
        let newLotto = Lotto(
            type: self.lottoType,
            date: selectedDate,
            purchaseAmount: self.purchaseAmount.value ?? 0,
            winningAmount: self.winningAmount.value ?? 0
        )
        
        return lottoRepository.saveLotto(newLotto)
    }
}
