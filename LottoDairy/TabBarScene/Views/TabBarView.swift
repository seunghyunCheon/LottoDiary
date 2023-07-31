//
//  TabBarView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/14.
//

import UIKit

final class TabBarView: UITabBar {

    private var shapeLayer: CALayer?

    private enum Constraints {
        static let lottoQRButtonSize: CGFloat = 80
        static let halfLottoQRButtonSize: CGFloat = 80 / 2
        static let pathRadius: CGFloat = halfLottoQRButtonSize + 5
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureTabBar()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = sizeThatFits.height + 5
        
        return sizeThatFits
    }

    override func draw(_ rect: CGRect) {
        configureCurveShape()
        configureLottoQRButton()
    }

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard !clipsToBounds && !isHidden && alpha > 0 else { return nil }
        for member in subviews.reversed() {
            let subPoint = member.convert(point, from: self)
            guard let result = member.hitTest(subPoint, with: event) else { continue }
            return result
        }
        return nil
    }

    private func configureTabBar() {
        barStyle = .black
        tintColor = .designSystem(.white)
        items?.forEach { tabBarItem in
            tabBarItem.setTitleTextAttributes(
            [.font : UIFont.gmarketSans(size: .caption, weight: .medium)],
            for: .normal
            )
        }
    }

    private func configureLottoQRButton() {
        let x = (bounds.width / 2) - Constraints.halfLottoQRButtonSize
        let lottoQRButton = LottoQRButton(frame: CGRect(x: x,
                                                        y: -Constraints.halfLottoQRButtonSize,
                                                        width: Constraints.lottoQRButtonSize,
                                                        height: Constraints.lottoQRButtonSize))
        lottoQRButton.clipsToBounds = true
        lottoQRButton.layer.cornerRadius = Constraints.halfLottoQRButtonSize
        addSubview(lottoQRButton)
    }

    private func configureCurveShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.designSystem(.gray2B2C35)?.cgColor

        if let oldShapeLayer = self.shapeLayer {
            layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: .zero)
        }
        self.shapeLayer = shapeLayer
    }

    private func createPath() -> CGPath {
        let path = UIBezierPath()

        path.move(to: .zero)
        let halfPoint = CGPoint(x: frame.width / 2, y: .zero)
        path.addArc(withCenter: halfPoint,
                    radius: Constraints.pathRadius,
                    startAngle: .pi,
                    endAngle: .zero,
                    clockwise: false)
        path.addLine(to: CGPoint(x: frame.width, y: .zero))
        path.addLine(to: CGPoint(x: frame.width, y: frame.height))
        path.addLine(to: CGPoint(x: .zero, y: frame.height))

        return path.cgPath
    }
}
