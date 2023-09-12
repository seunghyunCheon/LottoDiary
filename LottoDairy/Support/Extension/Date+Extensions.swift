//
//  Date+Extensions.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation

extension Date {
    static let today = Date()
    
    func equalsDate(with date: Date) -> Bool {
        let calendar = Calendar.current
            
        let todayComponent = calendar.dateComponents([.year, .month, .day], from: self)
        let dateComponent = calendar.dateComponents([.year, .month, .day], from: date)
            
        return (todayComponent == dateComponent)
    }
}
