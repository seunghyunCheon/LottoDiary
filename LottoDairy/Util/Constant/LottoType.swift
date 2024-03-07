//
//  LottoType.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

enum LottoType: String, CaseIterable {
    case lotto = "로또"
    case spitto = "스피또"

    var imageName: String {
        switch self {
        case .lotto: return "lotto"
        case .spitto: return "spito"
        }
    }
}
