//
//  DateCellViewModel.swift
//  LottoDairy
//
//  Created by Brody on 2023/08/18.
//

import Combine
import Foundation

extension Date {

    /**
     # dateCompare
     - Parameters:
        - fromDate: 비교 대상 Date
     - Note: 두 날짜간 비교해서 과거(Future)/현재(Same)/미래(Past) 반환
    */
    public func dateCompare(fromDate: Date) -> String {
        var strDateMessage:String = ""
        let result:ComparisonResult = self.compare(fromDate)
        switch result {
        case .orderedAscending:
            strDateMessage = "Future"
            break
        case .orderedDescending:
            strDateMessage = "Past"
            break
        case .orderedSame:
            strDateMessage = "Same"
            break
        default:
            strDateMessage = "Error"
            break
        }
        return strDateMessage
    }
}

final class DateCellViewModel {
    
    @Published var dateNumber: String
    @Published var isIncludeInMonth: Bool
    @Published var isToday: Bool = false
    
    var date: Date
    
    init(dayComponent: DayComponent) {
        self.dateNumber = dayComponent.number
        self.isIncludeInMonth = dayComponent.isIncludeInMonth
        self.date = dayComponent.date
        self.isToday = self.checkTodayDate(with: dayComponent.date)
    }
    
    func validateCellState() {
        self.isToday = self.checkTodayDate(with: date)
    }
    
    private func checkTodayDate(with date: Date) -> Bool {
        let calendar = Calendar.current
            
        let todayComponent = calendar.dateComponents([.year, .month, .day], from: Date())
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: date)
            
        return (todayComponent == dateComponent)
    }
}
