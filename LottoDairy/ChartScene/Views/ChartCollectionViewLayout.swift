//
//  ChartCollectionViewLayout.swift
//  LottoDairy
//
//  Created by Sunny on 3/14/24.
//

import UIKit

struct ChartCollectionViewLayout {
    static func createInformationListLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNum, env) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0 / 3.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.interItemSpacing = .fixed(Constant.interItemSpacing)

            let section = NSCollectionLayoutSection(group: group)
            return section
        }

        return layout
    }
}

extension ChartCollectionViewLayout {
    private enum Constant {
        static let interItemSpacing: CGFloat = 25
    }
}
