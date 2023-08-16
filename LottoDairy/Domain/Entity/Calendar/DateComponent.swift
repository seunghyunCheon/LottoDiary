//
//  DateComponent.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation

struct DayComponent: Hashable {

    let date: Date
    let isIncludeInMonth: Bool
}

extension DayComponent {

    var number: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"

        return formatter.string(from: date)
    }
}
