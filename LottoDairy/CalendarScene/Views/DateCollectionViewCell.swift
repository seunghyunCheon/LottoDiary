//
//  DateCollectionViewCell.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit

protocol CellBaseDateChangeDelegate: AnyObject {
    func changeBaseDate(with: Date)
}

final class DateCollectionViewCell: UICollectionViewCell {

    lazy var monthlyCollectionView: UICollectionView = {
        let monthlyCollectionViewLayout = MonthlyCollectionViewLayout()

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: monthlyCollectionViewLayout.createLayout()
        )
        collectionView.register(DateCell.self)
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .designSystem(.backgroundBlack)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var days: [DayComponent]?
    weak var delegate: CellBaseDateChangeDelegate?

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
        NSLayoutConstraint.activate([
            monthlyCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            monthlyCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            monthlyCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            monthlyCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func configuremonthlyCollectionViewDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Int, DayComponent>(
            collectionView: self.monthlyCollectionView
        ) { collectionView, indexPath, item in
            guard let days = self.days else { return UICollectionViewCell() }
            let dateCollectionViewCell: DateCell = collectionView.dequeue(for: indexPath)
            let cellViewModel = DateCellViewModel(dayComponent: days[indexPath.row])
            dateCollectionViewCell.provide(viewModel: cellViewModel)
            
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

extension DateCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let days = self.days else {
            return
        }
        
        self.delegate?.changeBaseDate(with: days[indexPath.row].date)
    }
}
