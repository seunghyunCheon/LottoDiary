//
//  TabBarComponents.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/14.
//

enum TabBarComponents: CaseIterable {
    case calendar
    case home
    case empty
    case chart
    case numbers
    
    var title: String {
        switch self {
        case .calendar:
            return "달력"
        case .home:
            return "홈"
        case .chart:
            return "차트"
        case .numbers:
            return "번호 추첨"
        case .empty:
            return ""
        }
    }
    
    var systemName: String {
        switch self {
        case .calendar:
            return "calendar.badge.plus"
        case .home:
            return "house"
        case .chart:
            return "chart.bar"
        case .numbers:
            return "number.circle"
        case .empty:
            return ""
        }
    }
}
