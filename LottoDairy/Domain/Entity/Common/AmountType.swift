//
//  AmountType.swift
//  LottoDairy
//
//  Created by Sunny on 10/14/23.
//

import UIKit

enum AmountType: String {
    case goal = "목표 금액"
    case buy = "구매 금액"
    case win = "당첨 금액"

    var image: UIImage? {
        switch self {
        case .goal:
            return UIImage(named: "goal")
        case .buy:
            return UIImage(named: "buy")
        case .win:
            return UIImage(named: "win")
        }
    }
}
