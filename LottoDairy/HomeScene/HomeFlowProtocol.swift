//
//  HomeFlowProtocol.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

protocol HomeFlowProtocol: Presentable {
    var onSetting: (() -> Void)? { get set }
}
