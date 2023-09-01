//
//  UIView+Extensions.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/28.
//

import UIKit

extension UIView {
    func addSubviews(_ views: [UIView]) {
        views.forEach { self.addSubview($0) }
    }
}
