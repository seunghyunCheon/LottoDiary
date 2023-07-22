//
//  UserDefaultsPersistenceServiceProtocol.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/22.
//

protocol UserDefaultsPersistenceServiceProtocol {
    func set(key: String, value: Any?)
    func get<T>(key: String) -> T?
}
