//
//  DateCellViewModel.swift
//  LottoDairy
//
//  Created by Brody on 2023/08/18.
//

import Combine

final class DateCellViewModel {
    
    @Published var date: String
    @Published var isIncludeInMonth: Bool
    
    init(dayComponent: DayComponent) {
        self.date = dayComponent.number
        self.isIncludeInMonth = dayComponent.isIncludeInMonth
    }
}
