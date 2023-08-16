//
//  CalendarViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation

final class CalendarViewModel {

    private let calendarUseCase: CalendarUseCase

    private var baseDate: Date = .today

    private var threeMonthlyDays: [[DayComponent]] {
        return calendarUseCase.getDaysInThreeMonth(for: baseDate)
    }

    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }

    func getThreeMonthlyDays() -> [[DayComponent]] {
        return threeMonthlyDays
    }

    func updatePreviousBaseDate() {
        self.baseDate = calendarUseCase.calculatePreviousMonth(by: baseDate)
    }

    func updateNextBaseDate() {
        self.baseDate = calendarUseCase.calculateNextMonth(by: baseDate)
    }
}
