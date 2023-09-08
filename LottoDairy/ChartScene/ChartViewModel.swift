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

struct ChartComponents {

    var month: Int
    var account: Double
}

struct ChartInformationComponents: Hashable {

    enum ChartInformationType: String {
        case goal = "목표 금액"
        case buy = "구매 금액"
        case win = "당첨 금액"

        var image: UIImage {
            switch self {
            case .goal:
                return .actions
            case .buy:
                return .add
            case .win:
                return .remove
            }
        }
    }

    enum ChartInformationSection {
        case main
    }

    let image: UIImage
    let type: ChartInformationType
    var amount: String
    // 1, 2 : (달성 여부, nil)
    // 3 : (+/-, 금액)
    var result: (result: Bool, percent: Int?)?

    init(type: ChartInformationType, amount: Int, result: (result: Bool, percent: Int?)? = nil) {
        self.image = type.image
        self.type = type
        self.amount = amount.convertToDecimal()
        self.result = result
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(result?.result)
        hasher.combine(result?.percent)
    }

    static func == (lhs: ChartInformationComponents, rhs: ChartInformationComponents) -> Bool {
        return lhs.amount == rhs.amount && lhs.result?.result == rhs.result?.result && lhs.result?.percent == rhs.result?.percent
    }

    static let mock: [ChartInformationComponents] = {
        return [
            ChartInformationComponents(
                type: .goal,
                amount: 3000,
                result: (true, nil)
            ),
            ChartInformationComponents(
                type: .buy,
                amount: 1000
            ),
            ChartInformationComponents(
                type: .win,
                amount: 6000,
                result: (true, 200)
            )
        ]
    }()
}
