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

enum Direction {
    case left
    case none
    case right
}

final class CalendarViewModel {

    var baseDate = CurrentValueSubject<Date, Never>(.today)
    var days = CurrentValueSubject<[[DayComponent]], Never>([])
    var calendarShape: ScopeType = .month
    private let calendarUseCase: CalendarUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(calendarUseCase: CalendarUseCase) {
        self.calendarUseCase = calendarUseCase

        #if DEBUG
        self.debugBaseDate()
        #endif
    }

    func fetchDays() {
        switch calendarShape {
        case .month: self.fetchMonthlyDays()
        case .week: self.fetchWeeklyDays()
        }
    }

    func calculateMonthBaseDate(_ direction: Direction) {
        switch direction {
        case .left:
            self.baseDate.value = calendarUseCase.calculatePreviousMonth(by: baseDate.value)
        case .right:
            self.baseDate.value = calendarUseCase.calculateNextMonth(by: baseDate.value)
        case .none: break
        }
    }

    func calculateWeekBaseDate(_ direction: Direction) {
        switch direction {
        case .left:
            self.baseDate.value = calendarUseCase.calculatePreviousWeek(by: baseDate.value)
        case .right:
            self.baseDate.value = calendarUseCase.calculateNextWeek(by: baseDate.value)
        case .none: break
        }
    }

    func changeBaseDate(with date: Date) {
        self.baseDate.value = date
    }
    
    func toggleCalendarShape() {
        self.calendarShape = (self.calendarShape == .month) ? .week : .month
    }

    private func fetchWeeklyDays() {
        calendarUseCase.getDaysInThreeWeek(for: baseDate.value)
            .sink { result in
            } receiveValue: { days in
                self.days.send(days)
            }
            .store(in: &cancellables)
    }

    private func fetchMonthlyDays() {
        calendarUseCase.getDaysInThreeMonth(for: baseDate.value)
            .sink { result in
            } receiveValue: { days in
                self.days.send(days)
            }
            .store(in: &cancellables)
    }

    private func debugBaseDate() {
        baseDate
            .sink { date in
                print("ℹ️ baseDate 변경 \nℹ️\(date)")
                print("-----------------------------------------")
            }
            .store(in: &cancellables)
    }
}
