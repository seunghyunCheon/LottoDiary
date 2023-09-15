//
//  CalendarFlowProtocol.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

protocol CalendarFlowProtocol: Presentable {
    var onAddLotto: (() -> Void)? { get set }
}

//extension CalendarFlowProtocol: HalfModalTransitioningDelegate { }
