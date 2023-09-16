//
//  CalendarUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation

final class CalendarUseCase {

    private let calendar = Calendar(identifier: .gregorian)

    // MARK: Functions - Public
    func calculateNextWeek(by baseDate: Date) -> Date {
        guard let nextWeek = calendar.date(byAdding: .day, value: 7, to: baseDate) else {
            return .today
        }
        return nextWeek
    }

    func calculatePreviousWeek(by baseDate: Date) -> Date {
        guard let previousWeek = calendar.date(byAdding: .day, value: -7, to: baseDate) else {
            return .today
        }
        return previousWeek
    }

    func calculateNextMonth(by baseDate: Date) -> Date {
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: baseDate) else {
            return .today
        }
        return nextMonth
    }

    func calculatePreviousMonth(by baseDate: Date) -> Date {
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: baseDate) else {
            return .today
        }
        return previousMonth
    }

    func getDaysInThreeWeek(for baseDate: Date) -> [[DayComponent]] {
        let previousWeekDay = calculatePreviousWeek(by: baseDate)
        let nextWeekDay = calculateNextWeek(by: baseDate)
    
        let previous = generateWeekDays(for: previousWeekDay)
        let now = generateWeekDays(for: baseDate)
        let next = generateWeekDays(for: nextWeekDay)

        // 여기서 범위를 구해서 [lotto]를 가져온 뒤에 각 date에 맞게 map한 뒤에 return
        print(previous.first?.date)
        print(next.last?.date)
        return [previous, now, next]
    }

    func getDaysInThreeMonth(for baseDate: Date) -> [[DayComponent]] {
        guard let previousMonthDay = calendar.date(byAdding: .month, value: -1, to: baseDate),
                let nextMonthDay = calendar.date(byAdding: .month, value: 1, to: baseDate)
        else { return [[]] }

        let previous = getDaysInMonth(for: previousMonthDay)
        let now = getDaysInMonth(for: baseDate)
        let next = getDaysInMonth(for: nextMonthDay)

        return [previous, now, next]
    }

    // MARK: Functions - Private
    private func getDaysInMonth(for baseDate: Date) -> [DayComponent] {
        guard let monthlyData = try? getMonth(for: baseDate) else {
            return []
        }
        let firstDayOfMonth = monthlyData.firstDay

        let daysInThisMonth = generateMonthDays(for: baseDate)
        let daysInNextMonth = generateStartOfNextMonth(using: firstDayOfMonth)

        return daysInThisMonth + daysInNextMonth
    }

    private func getMonth(for baseDate: Date) throws -> MonthComponent {
        guard let numberOfDaysInMonth = calendar.range(of: .day, in: .month, for: baseDate)?.count,
              let firstDayOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: baseDate)
              ) else {
            throw CalendarError.isFailedGenerateMonthlyDate
        }

        let firstDayWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        let monthlyDay = MonthComponent(numberOfDays: numberOfDaysInMonth, firstDay: firstDayOfMonth, firstDayWeekday: firstDayWeekday)

        return monthlyDay
    }

    private func generateMonthDay(offsetBy dayOffset: Int, for baseDate: Date, isIncludeInMonth: Bool) -> DayComponent {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        let day = DayComponent(date: date,
                               isIncludeInMonth: isIncludeInMonth)

        return day
    }

    private func generateWeekDay(offsetBy dayOffset: Int, for baseDate: Date) -> DayComponent {
        let date = calendar.date(byAdding: .day, value: dayOffset, to: baseDate) ?? baseDate
        let day = DayComponent(date: date, isIncludeInMonth: true)

        return day
    }

    private func generateMonthDays(for baseDate: Date) -> [DayComponent] {
        guard let monthlyData = try? getMonth(for: baseDate) else {
            return []
        }

        let numberOfDays = monthlyData.numberOfDays
        let firstDayOfMonth = monthlyData.firstDay
        let offsetInFirstRow = monthlyData.firstDayWeekday

        let days: [DayComponent] = (1..<(numberOfDays + offsetInFirstRow)).map { day in

            let isIncludeInMonth = day >= offsetInFirstRow
            let dayOffset = isIncludeInMonth ? (day - offsetInFirstRow) : -(offsetInFirstRow - day)

            let day = generateMonthDay(offsetBy: dayOffset, for: firstDayOfMonth, isIncludeInMonth: isIncludeInMonth)

            return day
        }

        return days
    }

    private func generateWeekDays(for baseDate: Date) -> [DayComponent] {
        let firstDay = getStartDayOfWeek(for: baseDate)

        let firstWeekday = 0
        let lastWeekday =  6
        let days: [DayComponent] = (firstWeekday...lastWeekday).map { day in
            let day = generateWeekDay(offsetBy: day, for: firstDay)
            return day
        }
        return days
    }

    private func getStartDayOfWeek(for baseDate: Date) -> Date {
        let weekday = calendar.component(.weekday, from: baseDate)
        let daysToSubtract = calendar.firstWeekday - weekday
        let startOfWeek = calendar.date(byAdding: .day, value: daysToSubtract, to: baseDate)!
        return startOfWeek
    }

    private func generateStartOfNextMonth(using currentMonth: Date) -> [DayComponent] {
        guard let lastDay = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: currentMonth) else {
            return []
        }

        let additionalDays = 7 - calendar.component(.weekday, from: lastDay)
        guard additionalDays > 0 else {
            return []
        }

        let days: [DayComponent] = (1...additionalDays).map {
            generateMonthDay(offsetBy: $0, for: lastDay, isIncludeInMonth: false)
        }

        return days
    }
}

extension CalendarUseCase {
    enum CalendarError: Error {
        case isFailedGenerateMonthlyDate
    }
}
