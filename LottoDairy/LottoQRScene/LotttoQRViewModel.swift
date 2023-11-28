//
//  LotttoQRViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/10/10.
//

import Foundation
import Combine

enum LottoQRState {
    case invalid
    case notAnnounced
    case valid
}

final class LottoQRViewModel {
    
    private let lottoQRUseCase: LottoQRUseCase
    
    struct Input {
        let qrCodeDidRecognize: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let lottoQRValidation = PassthroughSubject<LottoQRState, Never>()
    }
    
    private var lottoURL = CurrentValueSubject<String, Never>("")
    
    private var cancellables: Set<AnyCancellable> = []
    
    init(lottoQRUseCase: LottoQRUseCase) {
        self.lottoQRUseCase = lottoQRUseCase
    }
    
    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }
    
    private func configureInput(_ input: Input) {
        input.qrCodeDidRecognize
            .flatMap { url -> AnyPublisher<Lotto, Error> in
                return self.lottoQRUseCase.crawlLottoResult(url)
            }
            .sink { completion in
                
            } receiveValue: { lotto in
                
            }
            .store(in: &cancellables)
        
    }
    
    private func configureOutput(from input: Input) -> Output {
        let output = Output()
        
        return output
    }
    
}
