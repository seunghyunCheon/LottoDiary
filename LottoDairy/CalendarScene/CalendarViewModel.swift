//
//  CalendarViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation
import Combine

final class CalendarViewModel {

    private let calendarUseCase: CalendarUseCase

    var baseDate = CurrentValueSubject<Date, Never>(.today)

    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }

    func getThreeMonthlyDays() -> [[DayComponent]] {
        return calendarUseCase.getDaysInThreeMonth(for: baseDate.value)
    }

    func updatePreviousBaseDate() {
        self.baseDate.value = calendarUseCase.calculatePreviousMonth(by: baseDate.value)
    }

    func updateNextBaseDate() {
        self.baseDate.value = calendarUseCase.calculateNextMonth(by: baseDate.value)
    }
}
