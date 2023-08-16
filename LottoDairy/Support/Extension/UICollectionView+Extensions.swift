//
//  UICollectionView+Extensions.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: T.reuseIdentifier)
    }

    func dequeue<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {

        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            return UICollectionViewCell() as! T
        }

        return cell
    }
}
