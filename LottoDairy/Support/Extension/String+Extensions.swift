//
//  String+Extensions.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/19.
//

import Foundation

extension String {
    func convertDecimalToInt() -> Int? {
        let removeAllSeparator = self.replacingOccurrences(of: ",", with: "")
        return Int(removeAllSeparator)
    }
}
