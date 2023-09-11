//
//  DateCellViewModel.swift
//  LottoDairy
//
//  Created by Brody on 2023/08/18.
//

import Combine
import Foundation

enum DateCellState {
    case none
    case today
    case selected
}

final class DateCellViewModel {
    
    @Published var dateNumber: String
    @Published var isIncludeInMonth: Bool
    @Published var cellState: DateCellState = .none
    
    private var date: Date
    
    init(dayComponent: DayComponent) {
        self.dateNumber = dayComponent.number
        self.isIncludeInMonth = dayComponent.isIncludeInMonth
        self.date = dayComponent.date
        validateCellState(with: false)
    }
    
    func validateCellState(with isSelected: Bool) {
        if !isIncludeInMonth {
            cellState = .none
            return
        }
        
        if checkTodayDate(with: date) {
            cellState = .today
            return
        }
        
        if isSelected {
            cellState = .selected
        } else {
            cellState = .none
        }
    }
    
    private func checkTodayDate(with date: Date) -> Bool {
        let calendar = Calendar.current
            
        let todayComponent = calendar.dateComponents([.year, .month, .day], from: Date())
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: date)
            
        return (todayComponent == dateComponent)
    }
}
