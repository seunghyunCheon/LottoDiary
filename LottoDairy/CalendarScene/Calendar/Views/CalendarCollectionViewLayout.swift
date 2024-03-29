//
//  MonthlyCollectionViewLayout.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit

struct CalendarCollectionViewLayout {

    static func createLayout(type: ScopeType, days: [DayComponent]) -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNum, env) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 7),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
            let weekdayCount = 7
            let column = days.count / weekdayCount > 5 ? 6 : 5
            
            var groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0 / CGFloat(column))
            )
            if type == .week {
                groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(1.0))
            }
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            return section
        }
        
        return layout
    }
}
