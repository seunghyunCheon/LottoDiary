//
//  DateCollectionViewCell.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit

final class DateCollectionViewCell: UICollectionViewCell {

    private lazy var monthlyCollectionView: UICollectionView = {
        let monthlyCollectionViewLayout = MonthlyCollectionViewLayout()

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: monthlyCollectionViewLayout.createLayout()
        )
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.register(DateCell.self)
        collectionView.dataSource = self.dataSource
        return collectionView
    }()

    private var days: [DayComponent]?

    private var dataSource: UICollectionViewDiffableDataSource<Int, DayComponent>?

    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)

        setupDateCollectionViewCell()
        configuremonthlyCollectionViewDataSource()
        configureSnapshot()
    }

    func configure(with dayComponent: [DayComponent]) {
        self.days = dayComponent
    }

    private func setupDateCollectionViewCell() {
        contentView.addSubview(monthlyCollectionView)
        monthlyCollectionView.frame = contentView.bounds
    }

    private func configuremonthlyCollectionViewDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Int, DayComponent>(
            collectionView: self.monthlyCollectionView
        ) { collectionView, indexPath, item in
            guard let days = self.days else { return UICollectionViewCell() }
            let dateCollectionViewCell: DateCell = collectionView.dequeue(for: indexPath)
            dateCollectionViewCell.configure(with: days[indexPath.row])
            return dateCollectionViewCell
        }
    }

    private func configureSnapshot() {
        guard let days = days else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, DayComponent>()
        snapshot.appendSections([0])
        snapshot.appendItems(days)
        self.dataSource?.apply(snapshot)
    }
}

