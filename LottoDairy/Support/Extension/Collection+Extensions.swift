//
//  Collection+Extensions.swift
//  LottoDairy
//
//  Created by Sunny on 3/15/24.
//

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
