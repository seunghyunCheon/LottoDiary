//
//  LottoValidationState.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

enum PurchaseAmountValidationState {
    case empty
    case success
    case lowerboundViolated
    case upperboundViolated
    case invalidLetterIncluded
    
    var description: String {
        switch self {
        case .empty, .success:
            return ""
        case .lowerboundViolated:
            return "1000원 이상을 입력해주세요"
        case .upperboundViolated:
            return "100억원 이하를 입력해주세요"
        case .invalidLetterIncluded:
            return "숫자만 입력할 수 있어요"
        }
    }
}
