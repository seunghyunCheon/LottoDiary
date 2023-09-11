//
//  UICollectionViewCell+Extensions.swift
//  LottoDairy
//
//  Created by Sunny on 2023/09/03.
//

import UIKit

extension UICollectionViewCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
