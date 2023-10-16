//
//  HomeViewModel.swift
//  LottoDairy
//
//  Created by Sunny on 10/13/23.
//

import Foundation
import Combine

final class HomeViewModel {

    private let userUseCase: GoalSettingUseCase
    private let amountUseCase: ChartLottoUseCase

    struct Input {
        let viewWillAppearEvent: PassthroughSubject<Void, Never>
    }

    struct Output {
        let nickNameTextField =  PassthroughSubject<String, Never>()
        var month = 0
        var percent = CurrentValueSubject<Int, Never>(0)    // ??
        var goalAmount = CurrentValueSubject<Int?, Never>(nil)
        var purchaseAmount = CurrentValueSubject<Int?, Never>(nil)
        var winningAmount = CurrentValueSubject<Int?, Never>(nil)
    }

    private var cancellables: Set<AnyCancellable> = []

    private var year: Int = 0
    private var month: Int = 0

    @Published private var purchaseAmount: Int?
    @Published private var winningAmount: Int?


    init(
        amountUseCase: ChartLottoUseCase,
        userUseCase: GoalSettingUseCase
    ) {
        self.amountUseCase = amountUseCase
        self.userUseCase = userUseCase

        self.configureDate()
    }

    func transform(from input: Input) -> Output {
        self.configureInput(input)
        return configureOutput(from: input)
    }

    private func configureDate() {
        let date = amountUseCase.fetchToday()

        if self.year != date[0] {
            self.year = date[0]
        }

        if self.month != date[1] {
            self.month = date[1]
        }
    }

    private func configureInput(_ input: Input) {
        input.viewWillAppearEvent
            .sink { [self] in
                self.configureDate()
                self.userUseCase.loadUserInfo()

                self.amountUseCase.fetchLottoAmounts(year: self.year, month: self.month)
                    .sink { completion in
                        if case .failure(let error) = completion {
                            print(error)
                        }
                    } receiveValue: { (purchase, winning) in
                        self.purchaseAmount = purchase
                        self.winningAmount = winning
                    }
                    .store(in: &cancellables)
            }
            .store(in: &cancellables)
    }

    private func configureOutput(from input: Input) -> Output {
        var output = Output()

        output.month = self.month

        self.userUseCase.nickname
            .sink { name in
                output.nickNameTextField.send(name)
            }
            .store(in: &cancellables)

        self.userUseCase.goalAmount
            .sink { goal in
                output.goalAmount.send(goal)
            }
            .store(in: &cancellables)

        self.$purchaseAmount
            .sink { purchase in
                output.purchaseAmount.send(purchase)
            }
            .store(in: &cancellables)

        self.$winningAmount
            .sink { winning in
                output.winningAmount.send(winning)
            }
            .store(in: &cancellables)

        return output
    }

    // 목표 금액 별 구매 금액 퍼센테이지 계산
}
