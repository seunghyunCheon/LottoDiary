//
//  UserDefaultsPersistenceService.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/22.
//

import Foundation

final class UserDefaultsPersistenceService: UserDefaultsPersistenceServiceProtocol {
    
    func set(key: String, value: Any?) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func get<T>(key: String) -> T? {
        let value = UserDefaults.standard.object(forKey: key)
        return value as? T
    }
}
