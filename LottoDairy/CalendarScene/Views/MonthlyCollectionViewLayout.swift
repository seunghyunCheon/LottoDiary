//
//  MonthlyCollectionViewLayout.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit

struct MonthlyCollectionViewLayout {

    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNum, env) -> NSCollectionLayoutSection? in

            let itemSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth((1.0 / 7)), heightDimension: .fractionalHeight(1.0))
            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)

            let groupSize: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight((1.0 / 7)))
            let group: NSCollectionLayoutGroup = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let groupSize2: NSCollectionLayoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight((1.0)))
            let group2: NSCollectionLayoutGroup = NSCollectionLayoutGroup.vertical(layoutSize: groupSize2, subitems: [group])

            let section: NSCollectionLayoutSection = NSCollectionLayoutSection(group: group2)
            return section
        }
        return layout
    }
}
