//
//  LottoValidationController.swift
//  LottoDairy
//
//  Created by Sunny on 11/2/23.
//

import Combine
import Foundation

final class LottoValidationController {
    
    private let lottoValidationUseCase: LottoValidationUseCase

    private var roundNumberSet: [Int: [[Int]]] = [:]

    private var cancellables = Set<AnyCancellable>()

    init(lottoValidationUseCase: LottoValidationUseCase) {
        self.lottoValidationUseCase = lottoValidationUseCase
    }

    private func compareLottoNumbers(_ numbers: [[Int]], with result: [Int], bonus: [Int]) -> [Int?] {
        // 로또 번호와 결과 비교 로직 구현
        let comparedNumbers = numbers.map { number in
            let count = Set(number).intersection(Set(result)).count
            if count == 5 && number.contains(bonus[0]) {
                // 번호 5개 + 보너스 번호까지 있으면 "-5" (2등)
                return Optional(-5)
            } else {
                return count > 2 ? count : nil
            }
        }
        return comparedNumbers
    }
}
