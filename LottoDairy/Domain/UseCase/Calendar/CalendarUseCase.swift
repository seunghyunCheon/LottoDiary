//
//  CalendarUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation
import Combine

fileprivate enum CalendarUseCaseError: LocalizedError {
    case failedToFetchData
    
    var errorDescription: String? {
        switch self {
        case .failedToFetchData:
            return "데이터를 가져오는데 실패했습니다."
        }
    }
}

final class CalendarUseCase {

    private let calendar = Calendar(identifier: .gregorian)
    private let lottoRepository: LottoRepository
    
    init(lottoRepository: LottoRepository) {
        self.lottoRepository = lottoRepository
    }
    
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

    func getDaysInThreeWeek(for baseDate: Date) -> AnyPublisher<[[DayComponent]], Error> {
        let previousWeekDay = calculatePreviousWeek(by: baseDate)
        let nextWeekDay = calculateNextWeek(by: baseDate)
    
        let previous = generateWeekDays(for: previousWeekDay)
        let now = generateWeekDays(for: baseDate)
        let next = generateWeekDays(for: nextWeekDay)

        return fetchLottos(previous, now, next)
    }

    func getDaysInThreeMonth(for baseDate: Date) -> AnyPublisher<[[DayComponent]], Error> {
        let previousMonthDay = calendar.date(byAdding: .month, value: -1, to: baseDate) ?? .today
        let nextMonthDay = calendar.date(byAdding: .month, value: 1, to: baseDate) ?? .today

        let previous = getDaysInMonth(for: previousMonthDay)
        let now = getDaysInMonth(for: baseDate)
        let next = getDaysInMonth(for: nextMonthDay)
        
        return fetchLottos(previous, now, next)
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
    
    private func fetchLottos(
    _ previous: [DayComponent],
    _ now: [DayComponent],
    _ next: [DayComponent]
    ) -> AnyPublisher<[[DayComponent]], Error> {
        guard let previousFirstDay = previous.first?.date,
              let previousLastDay = previous.last?.date,
              let nowFirstDay = now.first?.date,
              let nowLastDay = now.last?.date,
              let nextFirstDay = next.first?.date,
              let nextLastDay = next.last?.date else {
            return Fail(error: CalendarUseCaseError.failedToFetchData).eraseToAnyPublisher()
        }
        
        var previous = previous
        var now = now
        var next = next
        
        let previousRange = previousFirstDay...previousLastDay
        let nowRange = nowFirstDay...nowLastDay
        let nextRange = nextFirstDay...nextLastDay
        
        return lottoRepository.fetchLottos(with: previousFirstDay, and: nextLastDay)
            .flatMap { lottos -> AnyPublisher<[[DayComponent]], Error> in
                lottos.forEach { lotto in
                    if previousRange.contains(lotto.date),
                       let targetIdx = previous.firstIndex(where: { $0.date.equalsDate(with: lotto.date) }) {
                            previous[targetIdx].lottos.append(lotto)
                            return
                       }
                    
                    if nowRange.contains(lotto.date),
                       let targetIdx = now.firstIndex(where: { $0.date.equalsDate(with: lotto.date) }) {
                            now[targetIdx].lottos.append(lotto)
                            return
                       }
                    
                    if nextRange.contains(lotto.date),
                       let targetIdx = next.firstIndex(where: { $0.date.equalsDate(with: lotto.date) }) {
                            next[targetIdx].lottos.append(lotto)
                            return
                       }
                }
                return Just([previous, now, next]).setFailureType(to: Error.self).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}

extension CalendarUseCase {
    enum CalendarError: Error {
        case isFailedGenerateMonthlyDate
    }
}
