//
//  UIStackView+Extensions.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/27.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { self.addArrangedSubview($0) }
    }
}
