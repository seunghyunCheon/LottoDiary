//
//  Router.swift
//  LottoDairy
//
//  Created by Brody on 2023/06/30.
//

protocol Router: Presentable {
    
    func present(_ module: Presentable?, animated: Bool)
    
    func push(_ module: Presentable?, animated: Bool)
    
    func popModule(animated: Bool)
    
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    
    func setRootModule(_ module: Presentable?)
    
    func popToRootModule(animated: Bool)
}
