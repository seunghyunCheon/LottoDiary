//
//  DateComponent.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation

struct DayComponent: Hashable {

    let date: Date
    var isIncludeInMonth: Bool

    init(date: Date, isIncludeInMonth: Bool = false) {
        self.date = date
        self.isIncludeInMonth = isIncludeInMonth
    }
}

extension DayComponent {

    var number: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"

        return formatter.string(from: date)
    }
}
