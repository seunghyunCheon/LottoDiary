//
//  LottoBall.swift
//  LottoDairy
//
//  Created by Sunny on 3/14/24.
//

import UIKit

final class LottoBall: UIView {
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = .gmarketSans(size: .subheadLine, weight: .bold)
        label.textColor = .designSystem(.white)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(_ number: Int) {
        super.init(frame: .zero)

        setupView()
        configureView(number: number)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Layout
extension LottoBall {
    private func configureView(number: Int) {
        switch number {
        case 1..<10:
            self.backgroundColor = .designSystem(.mainYellow)
        case 10..<20:
            self.backgroundColor = .designSystem(.mainBlue)
        case 20..<30:
            self.backgroundColor = .designSystem(.mainOrange)
        case 30..<40:
            self.backgroundColor = .designSystem(.grayD8D8D8)
        default:
            self.backgroundColor = .designSystem(.mainGreen)
        }
        self.numberLabel.text = String(number)

        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(Constant.ballSize / 2)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupView() {
        self.addSubview(numberLabel)
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            self.heightAnchor.constraint(equalToConstant: Constant.ballSize),
            self.widthAnchor.constraint(equalToConstant: Constant.ballSize)
        ])
    }
}

// MARK: Constant
extension LottoBall {
    enum Constant {
        static let ballSize: CGFloat = 38
    }
}
