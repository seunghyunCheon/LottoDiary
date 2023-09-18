//
//  WinningAmountValidationState.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

enum WinningAmountValidationState {
    case empty
    case success
    case upperboundViolated
    case invalidLetterIncluded
    
    var description: String {
        switch self {
        case .empty, .success:
            return ""
        case .upperboundViolated:
            return "100억원 이하를 입력해주세요"
        case .invalidLetterIncluded:
            return "숫자만 입력할 수 있어요"
        }
    }
}
