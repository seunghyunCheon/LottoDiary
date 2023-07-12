//
//  Coordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/06/27.
//

// Domain, Data, Presentation, Protocol, Application, Resourece
// 

protocol Coordinator: AnyObject {
    
    var childCoordinators: [Coordinator] { get }
    func start()
}
