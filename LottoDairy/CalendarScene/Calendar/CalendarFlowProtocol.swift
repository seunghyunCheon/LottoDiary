//
//  CalendarFlowProtocol.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import Foundation

protocol CalendarFlowProtocol: Presentable {
    var onAddLotto: ((Date) -> Void)? { get set }
}
