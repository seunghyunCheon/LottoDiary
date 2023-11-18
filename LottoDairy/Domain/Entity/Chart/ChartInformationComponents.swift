//
//  ChartInformationComponents.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/09.
//

import UIKit

enum ChartInformationSection {
    case main
}

struct ChartInformationComponents: Hashable {

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

    let image: UIImage
    let type: AmountType
    var amount: String
    // 1, 2 : (달성 여부, nil)
    // 3 : (+/-, 금액)
    var result: (result: Bool, percent: Int?)

    init(type: AmountType, amount: Int, result: (result: Bool, percent: Int?)) {
        self.image = type.image
        self.type = type
        self.amount = amount.convertToDecimal()
        self.result = result
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
        hasher.combine(type)
        hasher.combine(amount)
        hasher.combine(result.result)
        hasher.combine(result.percent)
    }

    static func == (lhs: ChartInformationComponents, rhs: ChartInformationComponents) -> Bool {
        return lhs.image == rhs.image && lhs.type == rhs.type && lhs.amount == rhs.amount &&
        lhs.result.result == rhs.result.result && lhs.result.percent == rhs.result.percent
    }
}
