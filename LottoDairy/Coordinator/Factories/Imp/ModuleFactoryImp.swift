//
//  ModuleFactoryImp.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

final class ModuleFactoryImp: HomeModuleFactory {
    
    func makeHomeFlow() -> HomeFlowProtocol {
        return HomeViewController()
    }
}
