//
//  URLResponse+Extensions.swift
//  LottoDairy
//
//  Created by Sunny on 1/23/24.
//

import Foundation

extension URLResponse {
    private var successRange: ClosedRange<Int> {
        return 200...299
    }

    var checkResponse: Bool {
        guard let httpResponse = self as? HTTPURLResponse, successRange.contains(httpResponse.statusCode) else {
            return false
        }
        #if DEBUG
        print("ℹ️ URLResponse's statusCode: \(httpResponse.statusCode)")
        print("-----------------------------------------")
        #endif

        return true
    }
}
