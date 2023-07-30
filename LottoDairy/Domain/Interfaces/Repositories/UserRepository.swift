//
//  UserRepository.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/22.
//

import Combine

protocol UserRepository {
    func fetchUserData() -> AnyPublisher<(String, String, Int), Error>
    func saveUserInfo(nickname: String, notificationCycle: String, goalAmount: Int) -> AnyPublisher<Int, Error>
}
