//
//  CalendarModuleFactory.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

protocol CalendarModuleFactory {
    func makeCalendarFlow() -> CalendarFlowProtocol
    func makeAddLottoView() -> AddLottoViewProtocol
}
