//
//  ChartViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Foundation
import Combine

final class ChartViewModel {

    private let chartUseCase: ChartUseCase

    struct Input {
        let viewDidLoadEvent: Just<Void>
        let dateHeaderTextFieldDidEditEvent: PassthroughSubject<[Int], Never>
    }

    struct Output {
        var dateHeaderFieldText = CurrentValueSubject<[Int], Never>([])
    }

    private var cancellables: Set<AnyCancellable> = []

    init(chartUseCase: ChartUseCase) {
        self.chartUseCase = chartUseCase
    }

    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }

    private func configureInput(_ input: Input) {
        input.viewDidLoadEvent
            .sink { [weak self] in
                self?.chartUseCase.loadDateHeaderValue()
            }
            .store(in: &cancellables)

        input.dateHeaderTextFieldDidEditEvent
            .sink { [weak self] date in
                // usecase의 년, 월과 연결
                self?.chartUseCase.setDateHeaderValue(date)
            }
            .store(in: &cancellables)

    }

    private func configureOutput(from input: Input) -> Output {
        let output = Output()

        self.chartUseCase.dateHeaderValue
            .sink { date in
                output.dateHeaderFieldText.send(date)
            }
            .store(in: &cancellables)

        return output
    }
}
