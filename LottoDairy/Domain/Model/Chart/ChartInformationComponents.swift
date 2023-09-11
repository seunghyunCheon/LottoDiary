//
//  ChartInformationComponents.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/09.
//

import UIKit

struct ChartInformationComponents: Hashable {

    enum ChartInformationType: String {
        case goal = "목표 금액"
        case buy = "구매 금액"
        case win = "당첨 금액"

        var image: UIImage {
            switch self {
            case .goal:
                return .actions
            case .buy:
                return .add
            case .win:
                return .remove
            }
        }
    }

    enum ChartInformationSection {
        case main
    }

    let image: UIImage
    let type: ChartInformationType
    var amount: String
    // 1, 2 : (달성 여부, nil)
    // 3 : (+/-, 금액)
    var result: (result: Bool, percent: Int?)?

    init(type: ChartInformationType, amount: Int, result: (result: Bool, percent: Int?)) {
        self.image = type.image
        self.type = type
        self.amount = amount.convertToDecimal()
        self.result = result
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(result?.result)
        hasher.combine(result?.percent)
    }

    static func == (lhs: ChartInformationComponents, rhs: ChartInformationComponents) -> Bool {
        return lhs.amount == rhs.amount && lhs.result?.result == rhs.result?.result && lhs.result?.percent == rhs.result?.percent
    }
}
