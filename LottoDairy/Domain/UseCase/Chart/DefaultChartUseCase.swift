//
//  DefaultChartUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Foundation
import Combine

final class DefaultChartUseCase: ChartUseCase {

    var year: Int = Calendar.current.component(.year, from: Date())
    var month: Int = Calendar.current.component(.month, from: Date())

    var dateHeaderValue = CurrentValueSubject<[Int], Never>([])

    func loadDateHeaderValue() {
        self.dateHeaderValue.send([year, month])
    }

    func setDateHeaderValue(_ date: [Int]) {
        self.year = date[0]
        self.month = date[1]
    }
}
