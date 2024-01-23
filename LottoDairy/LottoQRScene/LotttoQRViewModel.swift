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
    case valid(String)
}

final class LottoQRViewModel {
    
    private let lottoQRUseCase: LottoQRUseCase
    
    struct Input {
        let qrCodeDidRecognize: PassthroughSubject<String, Never>
    }
    
    struct Output {
        let lottoQRValidation = PassthroughSubject<LottoQRState, Never>()
        // 로또 성공적 조회 이후 back 했을 때, 달력 화면으로 전환하기
    }
    
    private var lottoURL = PassthroughSubject<String, Never>()

    private var validation = CurrentValueSubject<LottoQRState, Never>(.invalid)

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
            .sink { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { url in
                // url 유효성 검사
                if self.lottoQRUseCase.valid(url) {
                    #if DEBUG
                    print("ℹ️ 로또 유효성 검사 통과")
                    print("-----------------------------------------")
                    #endif

                    // 유효하다면 lottoURL에 send
                    self.validation.send(.valid(url))
                    self.lottoURL.send(url)
                } else {
                    #if DEBUG
                    print("ℹ️ 로또 유효성 검사 X")
                    print("-----------------------------------------")
                    #endif

                    // 유효하지 않다면
                    self.validation.send(.invalid)
                }
            }
            .store(in: &cancellables)
    }
    
    private func configureOutput(from input: Input) -> Output {
        let output = Output()

        self.validation
            .sink { state in
                output.lottoQRValidation.send(state)
            }
            .store(in: &cancellables)

        self.lottoURL
            .flatMap { url -> AnyPublisher<Lotto, Error> in
                return self.lottoQRUseCase.crawlLottoResult(url)
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            }, receiveValue: { lotto in })
            .store(in: &cancellables)

        return output
    }
}
