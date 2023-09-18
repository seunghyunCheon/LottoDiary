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
    case todaySelected
    case selected
}

final class DateCellViewModel {
    
    @Published var dateNumber: String
    @Published var isIncludeInMonth: Bool
    @Published var cellState: DateCellState = .none
    @Published var hasLotto: Bool
    
    private var date: Date
    
    init(dayComponent: DayComponent) {
        self.dateNumber = dayComponent.number
        self.isIncludeInMonth = dayComponent.isIncludeInMonth
        self.date = dayComponent.date
        self.hasLotto = !dayComponent.lottos.isEmpty
        validateCellState(with: false)
    }
    
    func validateCellState(with isSelected: Bool) {
        if !isIncludeInMonth {
            return
        }
        
        if Date.today.equalsDate(with: date) {
            cellState = .today
            if isSelected {
                cellState = .todaySelected
            }
            return
        }
        
        if isSelected {
            cellState = .selected
        } else {
            cellState = .none
        }
    }
}
