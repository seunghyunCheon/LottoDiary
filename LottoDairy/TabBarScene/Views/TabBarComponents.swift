//
//  TabBarComponents.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/14.
//

enum TabBarComponents: Int, CaseIterable {
    case calendar
    case home
    case lottoQR
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
        case .lottoQR:
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
        case .lottoQR:
            return ""
        }
    }

    enum LottoQR {
        static let title = "로또 QR"
        static let systemName = "qrcode"
    }

}
