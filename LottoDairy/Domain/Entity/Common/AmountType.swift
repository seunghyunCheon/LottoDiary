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
            return UIImage(named: "목표")
        case .buy:
            return UIImage(named: "구매")
        case .win:
            return UIImage(named: "win")
        }
    }
}
