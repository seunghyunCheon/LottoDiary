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
        let cancelButtonDidTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var purchaseAmountValidationErrorMessage = CurrentValueSubject<String?, Never>(.none)
        var winningAmountValidationErrorMessage = CurrentValueSubject<String?, Never>(.none)
        var purchaseAmountFieldText = CurrentValueSubject<String?, Never>(.none)
        var winningAmountFieldText = CurrentValueSubject<String?, Never>(.none)
        var okButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        var sendNewLotto = CurrentValueSubject<Lotto?, Never>(nil)
        var dismissTrigger = CurrentValueSubject<Bool, Never>(false)
    }
    
    private let addLottoUseCase: AddLottoUseCase
    private let addLottoValidationUseCase: AddLottoValidationUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(addLottoUseCase: AddLottoUseCase, addLottoValidationUseCase: AddLottoValidationUseCase) {
        self.addLottoUseCase = addLottoUseCase
        self.addLottoValidationUseCase = addLottoValidationUseCase
    }
    
    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }
    
    // MARK: - Private Methods
    
    private func configureInput(_ input: Input) {
        input.lottoTypeSelectEvent
            .sink { [weak self] lottoType in
                self?.addLottoUseCase.setLottoType(lottoType)
            }
            .store(in: &cancellables)
        
        input.purchaseAmountTextFieldDidEditEvent
            .sink { [weak self] amount in
                self?.addLottoValidationUseCase.validatePurchaseAmount(amount)
                self?.addLottoUseCase.setPurchaseAmount(amount)
            }
            .store(in: &cancellables)
        
        input.winningAmountTextFieldDidEditEvent
            .sink { [weak self] amount in
                self?.addLottoValidationUseCase.validateWinningAmount(amount)
                self?.addLottoUseCase.setWinningAmount(amount)
            }
            .store(in: &cancellables)
    }
    
    private func configureOutput(from input: Input) -> Output {
        let output = Output()
        self.addLottoValidationUseCase
            .purchaseAmountValidationState
            .sink { [weak self] state in
                output.purchaseAmountFieldText.send(self?.addLottoUseCase.purchaseAmount.value?.convertToDecimal())
                output.purchaseAmountValidationErrorMessage.send(state.description)
            }
            .store(in: &cancellables)
        
        self.addLottoValidationUseCase
            .winningAmountValidationState
            .sink { [weak self] state in
                output.winningAmountFieldText.send(self?.addLottoUseCase.winningAmount.value?.convertToDecimal())
                output.winningAmountValidationErrorMessage.send(state.description)
            }
            .store(in: &cancellables)
        
        self.addLottoValidationUseCase.okButtonEnabled
            .sink { state in
                output.okButtonEnabled.send((state))
            }
            .store(in: &cancellables)
        
        self.addLottoUseCase.purchaseAmount
            .sink { amount in
                output.purchaseAmountFieldText.send(amount?.convertToDecimal())
            }
            .store(in: &cancellables)
        
        self.addLottoUseCase.winningAmount
            .sink { amount in
                output.winningAmountFieldText.send(amount?.convertToDecimal())
            }
            .store(in: &cancellables)
        
        self.bindButtons(from: input, with: output)
        
        return output
    }
    
    private func bindButtons(from input: Input, with output: Output) {
        input.okButtonDidTapEvent
            .sink { [weak self] _ in
                let newLotto = self?.addLottoUseCase.addLotto()
                output.sendNewLotto.send(newLotto)
            }
            .store(in: &cancellables)
        
        input.cancelButtonDidTapEvent
            .sink {
                output.dismissTrigger.send(true)
            }
            .store(in: &cancellables)
    }
}
