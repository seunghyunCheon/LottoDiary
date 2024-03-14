//
//  LottoNumberView.swift
//  LottoDairy
//
//  Created by Sunny on 3/14/24.
//

import UIKit

final class LottoNumbersView: UIView {
    var lottoNumbers: [Int] = []

    private lazy var plusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.plus.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(numbers: [Int] = Int.makeRandomIntArray(count: 7)) {
        self.lottoNumbers = numbers
        super.init(frame: .zero)

        setupLottoBall()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Constant, ImageName
extension LottoNumbersView {
    private enum Constant {
        static let plusImageSize: CGFloat = 20
        static let leadingPadding: CGFloat = 14
        static let spacing: CGFloat = (DeviceInfo.screenWidth - (Constant.leadingPadding * 2 * 2) - (LottoBall.Constant.ballSize * 7) - 30) / 6
    }

    private enum Image: String {
        case plus = "PlusButton"

        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }
    }
}

// MARK: Layout
extension LottoNumbersView {
    func setupLottoBall() {
        let firstBall = LottoBall(lottoNumbers[0])
        let secondBall = LottoBall(lottoNumbers[1])
        let thirdBall = LottoBall(lottoNumbers[2])
        let fourthBall = LottoBall(lottoNumbers[3])
        let fifthBall = LottoBall(lottoNumbers[4])
        let sixthBall = LottoBall(lottoNumbers[5])
        let bounusBall = LottoBall(lottoNumbers[6])

        self.addSubviews([
            firstBall, secondBall, thirdBall, fourthBall, fifthBall, sixthBall, plusImage, bounusBall
        ])

        NSLayoutConstraint.activate([
            firstBall.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Constant.leadingPadding),
            firstBall.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            secondBall.leadingAnchor.constraint(equalTo: firstBall.trailingAnchor, constant: Constant.spacing),
            secondBall.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            thirdBall.leadingAnchor.constraint(equalTo: secondBall.trailingAnchor, constant: Constant.spacing),
            thirdBall.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            fourthBall.leadingAnchor.constraint(equalTo: thirdBall.trailingAnchor, constant: Constant.spacing),
            fourthBall.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            fifthBall.leadingAnchor.constraint(equalTo: fourthBall.trailingAnchor, constant: Constant.spacing),
            fifthBall.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            sixthBall.leadingAnchor.constraint(equalTo: fifthBall.trailingAnchor, constant: Constant.spacing),
            sixthBall.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            plusImage.leadingAnchor.constraint(equalTo: sixthBall.trailingAnchor, constant: Constant.spacing),
            plusImage.widthAnchor.constraint(equalToConstant: Constant.plusImageSize),
            plusImage.centerYAnchor.constraint(equalTo: self.centerYAnchor),

            bounusBall.leadingAnchor.constraint(equalTo: plusImage.trailingAnchor, constant: Constant.spacing),
            bounusBall.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
