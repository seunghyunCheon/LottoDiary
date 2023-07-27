//
//  MoneyInformationStackView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/26.
//

import UIKit

final class MoneyInformationStackView: UIStackView {

    init() {
        super.init(frame: .zero)

        setupSubviews()
        configureStackView()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        let goal = MoneyInformationView(title: "목표",
                                        money: "100,000원",
                                        backgroundColor: .red)
        let buy = MoneyInformationView(title: "구매금액",
                                       money: "200,000원",
                                       backgroundColor: .systemGreen)
        let win = MoneyInformationView(title: "당첨금액",
                                       money: "4000원",
                                       backgroundColor: .blue)
        addArrangedSubviews([goal, buy, win])
    }

    private func configureStackView() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 15
    }
}

extension MoneyInformationStackView {
    private class MoneyInformationView: UIStackView {

        private var title: UILabel
        private var money: UILabel

        init(title: String, money: String, backgroundColor: UIColor) {
            self.title = GmarketSansLabel(text: title, color: .white, alignment: .center)
            self.money = GmarketSansLabel(text: money, color: .white, alignment: .center)
            super.init(frame: .zero)

            configureStackView(backgroundColor)
        }

        required init(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        private func configureStackView(_ backColor: UIColor) {
            axis = .vertical
            clipsToBounds = true
            layer.cornerRadius = 20
            distribution = .fillEqually
            backgroundColor = backColor

            addArrangedSubview(title)
            addArrangedSubview(money)
        }
    }
}
