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

    enum ChartInformationPercentType {
        case minus
        case plus
        case zero

        var systemName: String {
            switch self {
            case .minus:
                return "arrowtriangle.down.fill"
            case .plus:
                return "arrowtriangle.up.fill"
            case .zero:
                return "minus"
            }
        }

        var color: UIColor {
            switch self {
            case .minus:
                return .designSystem(.mainBlue) ?? .systemBlue
            case .plus:
                return .designSystem(.mainOrange) ?? .systemOrange
            case .zero:
                return .designSystem(.mainGreen) ?? .systemGreen
            }
        }
    }

    enum ChartInformationResultType: String {
        case success = "달성 완료!"
        case fail = "달성 실패!"

        var color: UIColor? {
            switch self {
            case .success:
                return .designSystem(.mainGreen)
            case .fail:
                return .designSystem(.mainBlue)
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
    var result: (result: Bool, percent: Int?)

    init(type: ChartInformationType, amount: Int, result: (result: Bool, percent: Int?)) {
        self.image = type.image
        self.type = type
        self.amount = amount.convertToDecimal()
        self.result = result
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(amount)
        hasher.combine(result.result)
        hasher.combine(result.percent)
    }

    static func == (lhs: ChartInformationComponents, rhs: ChartInformationComponents) -> Bool {
        return lhs.amount == rhs.amount && lhs.result.result == rhs.result.result && lhs.result.percent == rhs.result.percent
    }
}