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

    var baseDate: Date = .today
    var days = CurrentValueSubject<[[DayComponent]], Never>([])
    var calendarShape: ScopeType = .month
    private let calendarUseCase: CalendarUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase
    }
    
    func fetchThreeWeeklyDays() {
        calendarUseCase.getDaysInThreeWeek(for: baseDate)
            .sink { completion in
                
            } receiveValue: { days in
                self.days.send(days)
            }
            .store(in: &cancellables)
    }

    func fetchThreeMonthlyDays() {
        calendarUseCase.getDaysInThreeMonth(for: baseDate)
            .sink { completion in
                
            } receiveValue: { days in
                self.days.send(days)
            }
            .store(in: &cancellables)
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
