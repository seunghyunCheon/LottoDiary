//
//  ChartUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import Combine

protocol ChartUseCase {
    var year: Int { get set }
    var month: Int { get set }
    var dateHeaderValue: CurrentValueSubject<[Int], Never> { get }

    func loadDateHeaderValue()
    func setDateHeaderValue(_ date: [Int])
}
