//
//  GoalSettingViewModel.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Foundation
import Combine

final class GoalSettingViewModel {
    
    struct Input {
        let viewDidLoadEvent: Just<Void>
        let nicknameTextFieldDidEditEvent: AnyPublisher<String, Never>
        let goalSettingTextFieldDidEditEvent: AnyPublisher<String, Never>
        let notificationTextFieldDidEditEvent: PassthroughSubject<String, Never>
        let okButtonDidTapEvent: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var nicknameText = CurrentValueSubject<String, Never>("")
        var notificationCycleText = CurrentValueSubject<String?, Never>(nil)
        var nicknameValidationErrorMessage = CurrentValueSubject<String?, Never>(.none)
        var goalAmountValidationErrorMessage = CurrentValueSubject<String?, Never>(.none)
        var goalAmountFieldText = CurrentValueSubject<String?, Never>(.none)
        var notificationCycleList = CurrentValueSubject<[NotificationCycle], Never>([])
        var okButtonEnabled = CurrentValueSubject<Bool, Never>(false)
        var signUpDidEnd = CurrentValueSubject<Bool, Never>(false)
        var signUpDidFail = CurrentValueSubject<String, Never>("")
    }
    
    private let goalSettingValidationUseCase: GoalSettingValidationUseCase
    private let goalSettingUseCase: GoalSettingUseCase
    private let isEdit: Bool
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Life Cycle
    
    init(
        isEdit: Bool = false,
        goalSettingValidationUseCase: GoalSettingValidationUseCase,
        goalSettingUseCase: GoalSettingUseCase
    ) {
        self.goalSettingValidationUseCase = goalSettingValidationUseCase
        self.goalSettingUseCase = goalSettingUseCase
        self.isEdit = isEdit
    }
    
    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }
    
    // MARK: - Private Methods
    
    private func configureInput(_ input: Input) {
        input.viewDidLoadEvent
            .sink { [weak self] in
                self?.goalSettingUseCase.loadNotificationCycle()
                if let self, self.isEdit {
                    self.goalSettingUseCase.loadUserInfo()
                    self.goalSettingValidationUseCase
                        .activateAllComponent()
                }
            }
            .store(in: &cancellables)

        input.nicknameTextFieldDidEditEvent
            .sink { [weak self] nickname in
                self?.goalSettingValidationUseCase.validateNickname(nickname)
                self?.goalSettingUseCase.setNickname(nickname)
            }
            .store(in: &cancellables)
        
        input.goalSettingTextFieldDidEditEvent
            .sink { [weak self] amount in
                self?.goalSettingValidationUseCase.validateAmount(amount)
                self?.goalSettingUseCase.setGoalAmount(amount)
            }
            .store(in: &cancellables)
        
        input.notificationTextFieldDidEditEvent
            .sink { [weak self] selectedCycle in
                self?.goalSettingUseCase.setNotificationCycle(selectedCycle)
                self?.goalSettingValidationUseCase
                    .activateNotificationCycle()
            }
            .store(in: &cancellables)
    }
    
    private func configureOutput(from input: Input) -> Output {
        let output = Output()
        self.goalSettingValidationUseCase.nicknameValidationState
            .sink { state in
                output.nicknameValidationErrorMessage.send(state.description)
            }
            .store(in: &cancellables)
        
        self.goalSettingValidationUseCase.goalAmountValidationState
            .sink { [weak self] state in                output.goalAmountFieldText.send(self?.goalSettingUseCase.goalAmount.value?.convertToDecimal())
                output.goalAmountValidationErrorMessage.send(state.description)
            }
            .store(in: &cancellables)
        
        self.goalSettingUseCase.notificationCycleList
            .sink { notificationCycleList in
                output.notificationCycleList.send(notificationCycleList)
            }
            .store(in: &cancellables)
        
        self.goalSettingValidationUseCase.okButtonEnabled
            .sink { state in
                output.okButtonEnabled.send((state))
            }
            .store(in: &cancellables)
        
        self.goalSettingUseCase.nickname
            .sink { nickname in
                output.nicknameText.send(nickname)
            }
            .store(in: &cancellables)
        
        self.goalSettingUseCase.goalAmount
            .sink { goalAmount in
                output.goalAmountFieldText.send(goalAmount?.convertToDecimal())
            }
            .store(in: &cancellables)
        
        self.goalSettingUseCase.selectedNotificationCycle
            .sink { notificationCycle in
                output.notificationCycleText.send(notificationCycle?.rawValue)
            }
            .store(in: &cancellables)
        
        self.bindSignUp(from: input, with: output)
        
        return output
    }
    
    private func bindSignUp(from input: Input, with output: Output) {
        input.okButtonDidTapEvent
            .flatMap { [weak self] _ -> AnyPublisher<Void, Error> in
                guard let self else {
                    return Empty().eraseToAnyPublisher()
                }
                
                return self.goalSettingUseCase.signUp()
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    output.signUpDidFail.send(error.localizedDescription)
                }
            }, receiveValue: {
                output.signUpDidEnd.send(true)
            })
            .store(in: &cancellables)
    }
}
