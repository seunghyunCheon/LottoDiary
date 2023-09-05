//
//  CalendarViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit
import Combine

final class CalendarViewModel {

    private let calendarUseCase: CalendarUseCase

    // 날짜를 불러오는 것과 선택된 것에 대한 baseDate를 분리.
    var baseDate = CurrentValueSubject<Date, Never>(.today)
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }

    func getBaseDate() -> Date {
        return baseDate.value
    }

    func getThreeWeeklyDays() -> [[DayComponent]] {
        return calendarUseCase.getDaysInThreeWeek(for: baseDate.value)
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

    func updatePreviousWeekBaseDate() {
        self.baseDate.value = calendarUseCase.calculatePreviousWeek(by: baseDate.value)
    }

    func updateNextWeekBaseDate() {
        self.baseDate.value = calendarUseCase.calculateNextWeek(by: baseDate.value)
    }
}
