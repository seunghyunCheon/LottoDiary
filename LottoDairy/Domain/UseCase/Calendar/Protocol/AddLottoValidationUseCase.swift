//
//  AddLottoValidationUseCase.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import Combine

protocol AddLottoValidationUseCase {
    var purchaseAmountValidationState: CurrentValueSubject<PurchaseAmountValidationState, Never> { get }
    var winningAmountValidationState: CurrentValueSubject<WinningAmountValidationState, Never> { get }
    var okButtonEnabled: CurrentValueSubject<Bool, Never> { get }
    func validatePurchaseAmount(_ text: String)
    func validateWinningAmount(_ text: String)
}
