//
//  CalendarViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit
import Combine

enum ScopeType {
    case month
    case week
}

final class CalendarViewModel {

    private let calendarUseCase: CalendarUseCase

    var baseDate: Date = .today
    
    var days = CurrentValueSubject<[[DayComponent]], Never>([])
    
    var calendarShape: ScopeType = .month
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }
    
    func fetchThreeWeeklyDays() {
        days.value = calendarUseCase.getDaysInThreeWeek(for: baseDate)
    }

    func fetchThreeMonthlyDays() {
        days.value = calendarUseCase.getDaysInThreeMonth(for: baseDate)
    }

    func updatePreviousBaseDate() {
        self.baseDate = calendarUseCase.calculatePreviousMonth(by: baseDate)
        self.fetchThreeMonthlyDays()
    }

    func updateNextBaseDate() {
        self.baseDate = calendarUseCase.calculateNextMonth(by: baseDate)
        self.fetchThreeMonthlyDays()
    }

    func updatePreviousWeekBaseDate() {
        self.baseDate = calendarUseCase.calculatePreviousWeek(by: baseDate)
        self.fetchThreeWeeklyDays()
    }

    func updateNextWeekBaseDate() {
        self.baseDate = calendarUseCase.calculateNextWeek(by: baseDate)
        self.fetchThreeWeeklyDays()
    }
    
    func changeBaseDate(with date: Date) {
        self.baseDate = date
    }
    
    func changeCalendarShape() {
        self.calendarShape = (self.calendarShape == .month) ? .week : .month
    }
}
