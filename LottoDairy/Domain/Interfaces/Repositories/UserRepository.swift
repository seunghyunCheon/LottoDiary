//
//  UserRepository.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/22.
//

protocol UserRepository {
    func saveUserInfo(nickname: String, notificationCycle: String)
}
