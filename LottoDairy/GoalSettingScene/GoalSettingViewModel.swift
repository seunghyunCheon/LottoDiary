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
    }
    
    struct Output {
        var nicknameTextFieldText = CurrentValueSubject<String?, Never>("")
        var validationErrorMessage = CurrentValueSubject<String?, Never>("")
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
                self?.goalSettingUseCase.validate(text: nickname)
            }
            .store(in: &cancellables)
    }
    
    private func createOutput(from input: Input) -> Output {
        let output = Output()
        
        self.goalSettingUseCase.nicknameValidationState
            .sink { [weak self] state in
                output.nicknameTextFieldText.send(self?.goalSettingUseCase.nickname)
                output.validationErrorMessage.send(state.description)
            }
            .store(in: &cancellables)
        
        return output
    }
}
