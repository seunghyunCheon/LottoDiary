//
//  GoalSettingViewModel.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Foundation

import Combine

final class GoalSettingViewModel {
    private let goalSettingUseCase: GoalSettingUseCase
    
    struct Input {
        let nicknameTextFieldDidEditEvent: AnyPublisher<String, Never>
        let goalSettingTextFieldDidEditEvent: AnyPublisher<String, Never>
    }
    
    struct Output {
        var nicknameValidationErrorMessage = CurrentValueSubject<String?, Never>("")
        var goalAmountValidationErrorMessage = CurrentValueSubject<String?, Never>("")
        var goalAmountFieldText = CurrentValueSubject<String?, Never>("")
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(goalSettingUseCase: GoalSettingUseCase) {
        self.goalSettingUseCase = goalSettingUseCase
    }
    
    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return createOutput(from: input)
    }
    
    private func configureInput(_ input: Input) {
        input.nicknameTextFieldDidEditEvent
            .sink { [weak self] nickname in
                self?.goalSettingUseCase.validateNickname(nickname)
            }
            .store(in: &cancellables)
        
        input.goalSettingTextFieldDidEditEvent
            .sink { [weak self] amount in
                self?.goalSettingUseCase.validateAmount(amount)
            }
            .store(in: &cancellables)
    }
    
    private func createOutput(from input: Input) -> Output {
        let output = Output()
        
        self.goalSettingUseCase.nicknameValidationState
            .sink { state in
                output.nicknameValidationErrorMessage.send(state.description)
            }
            .store(in: &cancellables)
        
        self.goalSettingUseCase.goalAmountValidationState
            .sink { [weak self] state in                output.goalAmountFieldText.send(self?.goalSettingUseCase.goalAmount?.convertToDecimal())
                output.goalAmountValidationErrorMessage.send(state.description)
            }
            .store(in: &cancellables)
        
        return output
    }
}
