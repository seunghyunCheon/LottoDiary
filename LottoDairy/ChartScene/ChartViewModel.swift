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
    }

    struct Output {
        var chartView = CurrentValueSubject<BarChartData?, Never>(nil)
        var dateHeaderFieldText = CurrentValueSubject<[Int], Never>([])
        var chartInformationCollectionView = CurrentValueSubject<[ChartInformationComponents], Never>([])
    }

    private var cancellables: Set<AnyCancellable> = []

    var selectedYear = CurrentValueSubject<Int, Never>(0)
    var selectedMonth = CurrentValueSubject<Int, Never>(0)

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

                if self?.selectedYear.value != year {
                    self?.selectedYear.send(year)
                } else if self?.selectedMonth.value != month {
                    self?.selectedMonth.send(month)
                }
            }
            .store(in: &cancellables)

        input.chartViewDidSelectEvent
            .sink { month in
                if self.selectedMonth.value != month {
                    self.selectedMonth.send(month)
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

        let today = self.chartUseCase.makeYearAndMonthOfToday()
        self.selectedYear.send(today[0])
        self.selectedMonth.send(today[1])

        self.selectedYear
            .sink { year in
                self.chartUseCase.makeBarChartData(year: year)
                    .sink { barChartData in
                        output.chartView.send(barChartData)
                    }
                    .store(in: &self.cancellables)

                self.chartUseCase.makeChartInformationComponents(year: year, month: self.selectedMonth.value)
                    .sink { chartInformationComponents in
                        output.chartInformationCollectionView.send(chartInformationComponents)
                    }
                    .store(in: &self.cancellables)
                output.dateHeaderFieldText.send([year, self.selectedMonth.value])
            }
            .store(in: &cancellables)

        self.selectedMonth
            .sink { month in
                self.chartUseCase.makeChartInformationComponents(year: self.selectedYear.value, month: month)
                    .sink { chartInformationComponents in
                        output.chartInformationCollectionView.send(chartInformationComponents)
                    }
                    .store(in: &self.cancellables)
                output.dateHeaderFieldText.send([self.selectedYear.value, month])
            }
            .store(in: &cancellables)

        return output
    }
}
