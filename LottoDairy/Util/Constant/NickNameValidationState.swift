//
//  SignUpValidationState.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

enum NickNameValidationState {
    case empty
    case lowerboundViolated
    case upperboundViolated
    case invalidLetterIncluded
    case success
    
    var description: String {
        switch self {
        case .empty, .success:
            return ""
        case .lowerboundViolated:
            return "최소 3자 이상 입력해주세요"
        case .upperboundViolated:
            return "최대 10자까지만 가능해요"
        case .invalidLetterIncluded:
            return "영문과 숫자만 입력할 수 있어요"
        }
    }
}
