//
//  ChartViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import UIKit
import Combine

final class ChartViewModel {

    private let chartUseCase: ChartUseCase

    struct Input {
        let dateHeaderTextFieldDidEditEvent: PassthroughSubject<[Int], Never>
    }

    struct Output {
        var dateHeaderFieldText = CurrentValueSubject<[Int], Never>([])
    }

    private var cancellables: Set<AnyCancellable> = []

    private var years = [Int]()
    private let months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    private var selectedYearIndex: Int = 0
    private var selectedMonthIndex: Int = 0

    init(chartUseCase: ChartUseCase) {
        self.chartUseCase = chartUseCase
    }

    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }

    func getYears() -> [Int] {
        return years
    }

    func getMonths() -> [Int] {
        return months
    }

    private func configureInput(_ input: Input) {
        input.dateHeaderTextFieldDidEditEvent
            .sink { [weak self] date in
                self?.selectedYearIndex = date[0]
                self?.selectedMonthIndex = date[1]
            }
            .store(in: &cancellables)
    }

    private func configureOutput(from input: Input) -> Output {
        let output = Output()

        self.chartUseCase.makeRangeOfYear()
            .sink { rangeOfYear in
                self.years = rangeOfYear
            }
            .store(in: &cancellables)

        self.chartUseCase.makeYearAndMonthOfToday()
            .sink { date in
                output.dateHeaderFieldText.send(date)
            }
            .store(in: &cancellables)

        return output
    }
}
