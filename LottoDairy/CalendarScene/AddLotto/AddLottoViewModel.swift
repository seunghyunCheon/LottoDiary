//
//  AddLottoViewModel.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

import Combine

final class AddLottoViewModel {
    
    struct Input {
        let lottoTypeSelectEvent: AnyPublisher<LottoType, Never>
        let purchaseAmountTextFieldDidEditEvent: AnyPublisher<String, Never>
        let winningAmountTextFieldDidEditEvent: AnyPublisher<String, Never>
        let okButtonDidTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var purchaseAmountValidationErrorMessage = CurrentValueSubject<String?, Never>(.none)
        var winningAmountValidationErrorMessage = CurrentValueSubject<String?, Never>(.none)
        var purchaseAmountFieldText = CurrentValueSubject<String?, Never>(.none)
        var winningAmountFieldText = CurrentValueSubject<String?, Never>(.none)
        var okButtonEnabled = CurrentValueSubject<Bool, Never>(false)
    }
    
    private let addLottoUseCase: AddLottoUseCase
    private let addLottoValidationUseCase: AddLottoValidationUseCase
    
    init(addLottoUseCase: AddLottoUseCase, addLottoValidationUseCase: AddLottoValidationUseCase) {
        self.addLottoUseCase = addLottoUseCase
        self.addLottoValidationUseCase = addLottoValidationUseCase
    }
}
