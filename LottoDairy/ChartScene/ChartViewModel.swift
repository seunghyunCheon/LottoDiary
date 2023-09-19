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
    private let chartInformationUseCase: ChartInformationUseCase

    struct Input {
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
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

    private(set) var years = [Int]()
    private(set) var months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

    init(chartUseCase: ChartUseCase, chartInformationUseCase: ChartInformationUseCase) {
        self.chartUseCase = chartUseCase
        self.chartInformationUseCase = chartInformationUseCase

        configureToday()
        configureYears()
    }

    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }

    private func configureYears() {
        self.years = self.chartInformationUseCase.makeRangeOfYears()
    }

    private func configureToday() {
        let today = self.chartInformationUseCase.makeYearAndMonthOfToday()
        self.selectedYear.send(today[0])
        self.selectedMonth.send(today[1])
    }

    private func configureInput(_ input: Input) {
        input.viewWillAppearEvent
            .sink {
                self.selectedYear.send(self.selectedYear.value)
            }
            .store(in: &cancellables)

        input.dateHeaderTextFieldDidEditEvent
            .sink { [weak self] date in
                let yearIndex = date[0], monthIndex = date[1]
                let year = self?.years[yearIndex] ?? 0, month = self?.months[monthIndex] ?? 0

                if self?.selectedYear.value != year {
                    self?.selectedYear.send(year)
                }

                if self?.selectedMonth.value != month {
                    self?.selectedMonth.send(month)
                }
            }
            .store(in: &cancellables)

        input.chartViewDidSelectEvent
            .sink { [weak self] month in
                if self?.selectedMonth.value != month {
                    self?.selectedMonth.send(month)
                }
            }
            .store(in: &cancellables)
    }

    private func configureOutput(from input: Input) -> Output {
        let output = Output()

        self.selectedYear
            .flatMap { year in
                return Publishers.CombineLatest (
                    self.chartUseCase.makeBarChartData(year: year),
                    self.chartInformationUseCase.makeChartInformationComponents(year: year, month: self.selectedMonth.value)
                )
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { (barChartData, chartInformationComponents) in
                output.chartView.send(barChartData)
                output.chartInformationCollectionView.send(chartInformationComponents)
            })
            .store(in: &cancellables)

        self.selectedMonth
            .flatMap { month in
                self.chartInformationUseCase.makeChartInformationComponents(year: self.selectedYear.value, month: month)
            }
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { chartInformationComponents in
                output.chartInformationCollectionView.send(chartInformationComponents)
            })
            .store(in: &cancellables)

        self.selectedYear
            .sink { year in
                output.dateHeaderFieldText.send([year, self.selectedMonth.value])
            }
            .store(in: &cancellables)

        self.selectedMonth
            .sink { month in
                output.dateHeaderFieldText.send([self.selectedYear.value, month])
            }
            .store(in: &cancellables)

        return output
    }
}
