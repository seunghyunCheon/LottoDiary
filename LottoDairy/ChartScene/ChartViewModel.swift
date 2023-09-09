//
//  ChartViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import UIKit
import Combine
import DGCharts

final class ChartViewModel {

    private let chartUseCase: ChartUseCase

    struct Input {
        let dateHeaderTextFieldDidEditEvent: PassthroughSubject<[Int], Never>
        let chartViewDidSelectEvent: PassthroughSubject<Int, Never>
        var selectedYear = CurrentValueSubject<Int, Never>(0)
        var selectedMonth = CurrentValueSubject<Int, Never>(0)
    }

    struct Output {
        var dateHeaderFieldText = CurrentValueSubject<[Int], Never>([])
        var chartView = CurrentValueSubject<BarChartData?, Never>(nil)
        var chartInformationCollectionView = CurrentValueSubject<[ChartInformationComponents], Never>([])
    }

    private var cancellables: Set<AnyCancellable> = []

    private var years = [Int]()
    private let months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

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
                let yearIndex = date[0], monthIndex = date[1]
                let year = self?.years[yearIndex] ?? 0
                let month = self?.months[monthIndex] ?? 0

                if input.selectedYear.value != year {
                    input.selectedYear.send(year)
                } else if input.selectedMonth.value != month {
                    input.selectedMonth.send(month)
                }
            }
            .store(in: &cancellables)

        input.chartViewDidSelectEvent
            .sink { month in
                if input.selectedMonth.value != month {
                    input.selectedMonth.send(month)
                }
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
                input.selectedYear.send(date[0])
                input.selectedMonth.send(date[1])
            }
            .store(in: &cancellables)

        input.selectedYear
            .sink { year in
                output.dateHeaderFieldText.send([year, input.selectedMonth.value])
                let chartData = self.chartUseCase.makeBarChartData(year: year)
                output.chartView.send(chartData)
                let chartInformationComponents =  self.chartUseCase.makeChartInformationComponents(
                    year: input.selectedYear.value,
                    month: input.selectedMonth.value
                )
                output.chartInformationCollectionView.send(chartInformationComponents)
            }
            .store(in: &cancellables)

        input.selectedMonth
            .sink { month in
                output.dateHeaderFieldText.send([input.selectedYear.value, month])
                let chartInformationComponents =  self.chartUseCase.makeChartInformationComponents(
                    year: input.selectedYear.value,
                    month: input.selectedMonth.value
                )
                output.chartInformationCollectionView.send(chartInformationComponents)
            }
            .store(in: &cancellables)

        return output
    }
}
