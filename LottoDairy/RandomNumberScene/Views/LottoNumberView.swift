//
//  LottoNumberView.swift
//  LottoDairy
//
//  Created by Sunny on 3/14/24.
//

import UIKit

final class LottoNumbersView: UIView {
    private var lottoNumbers: [Int] = [] {
        didSet {
            self.removeAllBalls()
            self.setupLottoBall()
        }
    }

    private lazy var plusImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.plus.image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    init(numbers: [Int] = Int.makeRandomLottoNumber()) {
        self.lottoNumbers = numbers
        super.init(frame: .zero)

        setupLottoBall()
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateLottoNumbers() {
        self.lottoNumbers = Int.makeRandomLottoNumber()
    }

    private func removeAllBalls() {
        self.subviews.forEach { $0.removeFromSuperview() }
    }

    private func configureAnimation(balls: [UIView]) {
        // 각 볼에 대한 애니메이션 적용
        for (index, ball) in balls.enumerated() {
            // 각 볼의 초기 상태를 설정합니다. 예를 들어, 볼을 뷰의 상단으로 옮길 수 있습니다.
            ball.transform = CGAffineTransform(translationX: 0, y: -15)

            // 키 프레임 애니메이션을 사용하여 볼이 튕기는 효과를 추가합니다.
            UIView.animateKeyframes(withDuration: 0.4, delay: 0.05 * Double(index), options: [], animations: {
                // 첫 번째 키 프레임: 볼이 아래로 떨어집니다.
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                    ball.transform = CGAffineTransform(translationX: 0, y: 0)
                }
                // 두 번째 키 프레임: 볼이 약간 위로 튕깁니다.
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                    ball.transform = CGAffineTransform(translationX: 0, y: -10)
                }
                // 세 번째 키 프레임: 볼이 최종 위치로 돌아옵니다.
                UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                    ball.transform = .identity
                }
            })
        }
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
        let firstBall = LottoBall(lottoNumbers[safe:0])
        let secondBall = LottoBall(lottoNumbers[safe:1])
        let thirdBall = LottoBall(lottoNumbers[safe:2])
        let fourthBall = LottoBall(lottoNumbers[safe:3])
        let fifthBall = LottoBall(lottoNumbers[safe:4])
        let sixthBall = LottoBall(lottoNumbers[safe:5])
        let bounusBall = LottoBall(lottoNumbers[safe:6])

        let balls = [firstBall, secondBall, thirdBall, fourthBall, fifthBall, sixthBall, plusImage, bounusBall]
        self.addSubviews(balls)

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

        self.configureAnimation(balls: balls)
    }
}
