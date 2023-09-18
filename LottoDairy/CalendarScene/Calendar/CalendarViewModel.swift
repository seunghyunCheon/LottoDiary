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

    var baseDate = CurrentValueSubject<Date, Never>(.today)
    var days = CurrentValueSubject<[[DayComponent]], Never>([])
    var calendarShape: ScopeType = .month
    private let calendarUseCase: CalendarUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }
    
    func fetchThreeWeeklyDays() {
        calendarUseCase.getDaysInThreeWeek(for: baseDate.value)
            .sink { completion in
                
            } receiveValue: { days in
                self.days.send(days)
            }
            .store(in: &cancellables)
    }

    func fetchThreeMonthlyDays() {
        calendarUseCase.getDaysInThreeMonth(for: baseDate.value)
            .sink { completion in
                
            } receiveValue: { days in
                self.days.send(days)
            }
            .store(in: &cancellables)
    }

    func updatePreviousBaseDate() {
        self.baseDate.value = calendarUseCase.calculatePreviousMonth(by: baseDate.value)
        self.fetchThreeMonthlyDays()
    }

    func updateNextBaseDate() {
        self.baseDate.value = calendarUseCase.calculateNextMonth(by: baseDate.value)
        self.fetchThreeMonthlyDays()
    }

    func updatePreviousWeekBaseDate() {
        self.baseDate.value = calendarUseCase.calculatePreviousWeek(by: baseDate.value)
        self.fetchThreeWeeklyDays()
    }

    func updateNextWeekBaseDate() {
        self.baseDate.value = calendarUseCase.calculateNextWeek(by: baseDate.value)
        self.fetchThreeWeeklyDays()
    }
    
    func changeBaseDate(with date: Date) {
        self.baseDate.value = date
    }
    
    func changeCalendarShape() {
        self.calendarShape = (self.calendarShape == .month) ? .week : .month
    }
}
