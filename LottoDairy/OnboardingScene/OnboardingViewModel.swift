//
//  OnboardingViewModel.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/12.
//

import Combine

final class OnboardingViewModel {
    
    struct Input {
        let goalSettingButtonDidTab: AnyPublisher<Void, Never>
    }
    
    struct Output {
        var settingPageRequested = PassthroughSubject<Void, Never>()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    func transform(input: Input) -> Output {
        let output = Output()
        
        input.goalSettingButtonDidTab
            .sink {
                output.settingPageRequested.send(())
            }
            .store(in: &cancellables)
        
        return output
    }
}
