//
//  UserSetupController.swift
//  LottoDairy
//
//  Created by Sunny on 11/28/23.
//

import Foundation
import Combine

struct State {

    enum Instructor {
        case main, onboarding

        static func configure(isAuthorized: Bool) -> Instructor {
            if isAuthorized {
                return .main
            } else {
                return .onboarding
            }
        }
    }
}

protocol UserSetupFlowProtocol {
    var instructor: State.Instructor { get }
    func isUserSetup()
}

final class UserSetupController: UserSetupFlowProtocol {

    var instructor: State.Instructor {
        return State.Instructor.configure(isAuthorized: self.isAutorized)
    }

    private let userRepository: UserRepository

    private var isAutorized: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init(userRepository: UserRepository) {
        self.userRepository = userRepository

        self.isUserSetup()
    }

    func isUserSetup() {
        return userRepository.fetchUserData()
            .sink { completion in
                // 기존 유저 정보 없을 때
                if case .failure(let error) = completion {
                    print(error.localizedDescription)
                }
            } receiveValue: { result in
                #if DEBUG
                print("✅ 유저 정보 가져오기 성공! \n✅\(result)")
                print("-----------------------------------------")
                #endif
                self.isAutorized = true
            }
            .store(in: &cancellables)
    }
}
