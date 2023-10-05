//
//  LottoCollectionVIewLayout.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/12.
//

import UIKit

struct LottoCollectionViewLayout {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNum, env) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(90)
            )
            
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize, subitems: [item]
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 15,
                leading: 15,
                bottom: 0,
                trailing: 15
            )
            
            let footerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)
            )
            
            let sectionFooter = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: footerSize,
                elementKind: AddLottoFooterView.elementKind,
                alignment: .bottom
            )
            
            sectionFooter.contentInsets = NSDirectionalEdgeInsets(
                top: 15,
                leading: 0,
                bottom: 0,
                trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionFooter]
            
            return section
        }
        
        return layout
    }
}
