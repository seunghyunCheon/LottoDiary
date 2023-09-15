//
//  DefaultAddLottoValidationUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import Combine

final class DefaultAddLottoValidationUseCase: AddLottoValidationUseCase {
    
    var purchaseAmountValidationState = CurrentValueSubject<PurchaseAmountValidationState, Never>(PurchaseAmountValidationState.empty)
    var winningAmountValidationState = CurrentValueSubject<WinningAmountValidationState, Never>(WinningAmountValidationState.empty)
    var okButtonEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(
            purchaseAmountValidationState,
            winningAmountValidationState
        )
        .map { (purchaseAmountValidation, winningAmountValidation) in
            return purchaseAmountValidation == .success && winningAmountValidation == .success
        }
        .eraseToAnyPublisher()
    }
    
    func validatePurchaseAmount(_ text: String) {
        self.updatePurchaseAmountValidationState(of: text.convertDecimalToInt())
    }
    
    func validateWinningAmount(_ text: String) {
        self.updateWinningAmountValidationState(of: text.convertDecimalToInt())
    }
    
    private func updatePurchaseAmountValidationState(of purchaseAmount: Int?) {
        guard let purchaseAmount else {
            self.purchaseAmountValidationState.send(.empty)
            return
        }
        
        guard purchaseAmount >= 1_000 else {
            self.purchaseAmountValidationState.send(.lowerboundViolated)
            return
        }
        
        guard purchaseAmount <= 100_000_000_000 else {
            self.purchaseAmountValidationState.send(.upperboundViolated)
            return
        }
        
        self.purchaseAmountValidationState.send(.success)
    }
    
    private func updateWinningAmountValidationState(of winningAmount: Int?) {
        guard let winningAmount else {
            self.winningAmountValidationState.send(.empty)
            return
        }
        
        guard winningAmount >= 1_000 else {
            self.winningAmountValidationState.send(.lowerboundViolated)
            return
        }
        
        guard winningAmount <= 100_000_000_000 else {
            self.winningAmountValidationState.send(.upperboundViolated)
            return
        }
        
        self.winningAmountValidationState.send(.success)
    }
    
    
}
