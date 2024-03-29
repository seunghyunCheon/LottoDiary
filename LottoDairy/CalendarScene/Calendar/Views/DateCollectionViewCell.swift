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
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: CalendarCollectionViewLayout.createLayout(type: .month, days: [])
        )
        collectionView.register(DateCell.self)
        collectionView.dataSource = self.dataSource
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .designSystem(.backgroundBlack)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    weak var delegate: CellBaseDateChangeDelegate?

    private var baseDate = Date()
    
    private var days: [DayComponent]?
    
    private var scope: ScopeType = .month

    private var dataSource: UICollectionViewDiffableDataSource<Int, DayComponent>?
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        super.updateConfiguration(using: state)
        setupDateCollectionViewCell()
        configureMonthlyCollectionViewDataSource()
        configureSnapshot()
    }
    
    func configure(with dayComponent: [DayComponent], scope: ScopeType, baseDate: Date) {
        self.days = dayComponent
        self.scope = scope
        self.baseDate = baseDate
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
    
    private func configureMonthlyCollectionViewDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Int, DayComponent>(
            collectionView: self.monthlyCollectionView
        ) { collectionView, indexPath, item in
            guard let days = self.days else { return UICollectionViewCell() }
            let dateCollectionViewCell: DateCell = collectionView.dequeue(for: indexPath)
            let cellViewModel = DateCellViewModel(dayComponent: days[indexPath.row])
            dateCollectionViewCell.provide(viewModel: cellViewModel)
            if self.baseDate.equalsDate(with: days[indexPath.row].date) {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
            }
            
            return dateCollectionViewCell
        }
    }

    private func configureSnapshot() {
        guard let days = days else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Int, DayComponent>()
        snapshot.appendSections([0])
        snapshot.appendItems(days)

        let layout = CalendarCollectionViewLayout.createLayout(type: self.scope, days: days)
        monthlyCollectionView.setCollectionViewLayout(layout, animated: false)

        self.dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension DateCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let days = self.days, days[indexPath.row].isIncludeInMonth else { return }

        self.delegate?.changeBaseDate(with: days[indexPath.row].date)
    }
}
