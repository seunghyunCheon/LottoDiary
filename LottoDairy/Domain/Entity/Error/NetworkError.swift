//
//  NetworkError.swift
//  LottoDairy
//
//  Created by Sunny on 1/31/24.
//

import Foundation

enum NetworkError: Error {
    case emptyURL
    case invalidURL
    case outOfResponseCode
    case failedToEncoding
}
