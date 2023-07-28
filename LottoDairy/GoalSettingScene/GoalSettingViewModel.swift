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
        let viewDidLoadEvent: Just<Void>
        let nicknameTextFieldDidEditEvent: AnyPublisher<String, Never>
        let goalSettingTextFieldDidEditEvent: AnyPublisher<String, Never>
        let notificationTextFieldDidEditEvent: PassthroughSubject<String, Never>
        let okButtonDidTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var nicknameValidationErrorMessage = CurrentValueSubject<String?, Never>("")
        var goalAmountValidationErrorMessage = CurrentValueSubject<String?, Never>("")
        var goalAmountFieldText = CurrentValueSubject<String?, Never>("")
        var notificationCycleList = CurrentValueSubject<[NotificationCycle], Never>([])
        var okButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        var signUpDidEnd = CurrentValueSubject<Bool, Never>(false)
        var signUpDidFail = CurrentValueSubject<String, Never>("")
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(goalSettingUseCase: GoalSettingUseCase) {
        self.goalSettingUseCase = goalSettingUseCase
    }
    
    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }
    
    private func configureInput(_ input: Input) {
        input.viewDidLoadEvent
            .sink { [weak self] in
                self?.goalSettingUseCase.loadNotificationCycle()
            }
            .store(in: &cancellables)

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
        
        input.notificationTextFieldDidEditEvent
            .sink { [weak self] selectedCycle in
                self?.goalSettingUseCase.setNotificationCycle(selectedCycle)
            }
            .store(in: &cancellables)
    }
    
    private func configureOutput(from input: Input) -> Output {
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
        
        self.goalSettingUseCase.notificationCycleList
            .sink { notificationCycleList in
                output.notificationCycleList.send(notificationCycleList)
            }
            .store(in: &cancellables)
        
        self.goalSettingUseCase.okButtonEnabled
            .sink { state in
                output.okButtonEnabled.send((state))
            }
            .store(in: &cancellables)
        
        self.bindSignUp(from: input, with: output)
        
        return output
    }
    
    private func bindSignUp(from input: Input, with output: Output) {
        input.okButtonDidTapEvent
            .flatMap { [weak self] _ -> AnyPublisher<Int, Error> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                return self.goalSettingUseCase.signUp()
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    output.signUpDidFail.send(error.localizedDescription)
                }
            }, receiveValue: { _ in
                output.signUpDidEnd.send(true)
            })
            .store(in: &cancellables)
    }
}
