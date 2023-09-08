//
//  CalendarViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/17.
//

import UIKit
import Combine

final class CalendarViewController: UIViewController, CalendarFlowProtocol {

    private lazy var calendarCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        // 임시 사이즈 설정
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(DateCollectionViewCell.self)
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self.dataSource
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .designSystem(.backgroundBlack)
        
        return collectionView
    }()
    
    private var calendarHeaderView = CalendarHeaderView()

    private var dataSource: UICollectionViewDiffableDataSource<Section, [DayComponent]>?

    private var scrollDirection: ScrollDirection = .none

    private var calendarShape: ScopeType = .month

    private let viewModel: CalendarViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private var calendarAction: CalendarAction = .none

    private var calendarHeightConstraint: NSLayoutConstraint!
    
    init(viewModel: CalendarViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .designSystem(.backgroundBlack)
        calendarHeaderView.delegate = self
        setupCalendarHeaderView()
        setupCalendarView()
        configureCalendarCollectionViewDataSource()
        configureSnapshot()
        setupCenterXOffset()
        bindViewModel()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        switch calendarShape {
        case .month:
            let middleSectionIndex = calendarCollectionView.numberOfSections / 2
            let width = calendarCollectionView.collectionViewLayout.collectionViewContentSize.width
            let numberOfSections = CGFloat(calendarCollectionView.numberOfSections)
            let middleSectionX = width / numberOfSections * CGFloat(middleSectionIndex)
            calendarCollectionView.setContentOffset(CGPoint(x: middleSectionX, y: 0), animated: false)
        case .week:
            let middleSectionIndex = calendarCollectionView.numberOfSections / 2
            let width = calendarCollectionView.collectionViewLayout.collectionViewContentSize.width
            let numberOfSections = CGFloat(calendarCollectionView.numberOfSections)
            let middleSectionX = width / numberOfSections * CGFloat(middleSectionIndex)
            calendarCollectionView.setContentOffset(CGPoint(x: middleSectionX, y: 0), animated: false)
        }
    }
    
    private func setupCalendarHeaderView() {
        calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(calendarHeaderView)
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarHeaderView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: 15),
            calendarHeaderView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: -15),
            calendarHeaderView.topAnchor.constraint(equalTo: safe.topAnchor),
            calendarHeaderView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }

    private func setupCalendarView() {
        self.view.addSubview(calendarCollectionView)
        
        calendarHeightConstraint = calendarCollectionView.heightAnchor.constraint(equalToConstant: 300)
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            calendarCollectionView.topAnchor.constraint(equalTo: calendarHeaderView.bottomAnchor),
            calendarHeightConstraint
        ])
    }

    private func configureCalendarCollectionViewDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, [DayComponent]>(
            collectionView: self.calendarCollectionView
        ) { collectionView, indexPath, item in
            let dateCollectionViewCell: DateCollectionViewCell = collectionView.dequeue(for: indexPath)
            dateCollectionViewCell.configure(with: item, scope: self.calendarShape, baseDate: self.viewModel.baseDate.value)
            dateCollectionViewCell.delegate = self
            return dateCollectionViewCell
        }
    }

    private func configureSnapshot() {

        var snapshot = NSDiffableDataSourceSnapshot<Section, [DayComponent]>()
        snapshot.appendSections([.previous, .now, .next])

        switch calendarShape {
        case .month:
            let threeMonthlyDays = viewModel.getThreeMonthlyDays()
            snapshot.appendItems([threeMonthlyDays[0]], toSection: .previous)
            snapshot.appendItems([threeMonthlyDays[1]], toSection: .now)
            snapshot.appendItems([threeMonthlyDays[2]], toSection: .next)
        case .week:
            let threeWeeklyDays = viewModel.getThreeWeeklyDays()
            snapshot.appendItems([threeWeeklyDays[0]], toSection: .previous)
            snapshot.appendItems([threeWeeklyDays[1]], toSection: .now)
            snapshot.appendItems([threeWeeklyDays[2]], toSection: .next)
        }
        self.dataSource?.apply(snapshot)
    }

    private func setupCenterXOffset() {
        
        switch calendarShape {
        case .month:
            let middleSectionIndex = calendarCollectionView.numberOfSections / 2
            let width = calendarCollectionView.collectionViewLayout.collectionViewContentSize.width
            let numberOfSections = CGFloat(calendarCollectionView.numberOfSections)
            let middleSectionX = width / numberOfSections * CGFloat(middleSectionIndex)
            calendarCollectionView.setContentOffset(CGPoint(x: middleSectionX, y: 0), animated: false)
        case .week:
            let middleSectionIndex = calendarCollectionView.numberOfSections / 2
            let width = calendarCollectionView.collectionViewLayout.collectionViewContentSize.width
            let numberOfSections = CGFloat(calendarCollectionView.numberOfSections)
            let middleSectionX = width / numberOfSections * CGFloat(middleSectionIndex)
            calendarCollectionView.setContentOffset(CGPoint(x: middleSectionX, y: 0), animated: false)
        }
    }
    
    private func bindViewModel() {
        viewModel.baseDate
            .sink { date in
                if self.calendarAction == .select {
                    self.calendarAction = .none
                    return
                }
                
                self.updateYearAndMonth(with: date)
                self.updateSnapshot()
            }
            .store(in: &cancellables)
    }
    
    private func updateYearAndMonth(with date: Date) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        guard let updatedYear = components.year,
              let updatedMonth = components.month else {
            return
        }
        calendarHeaderView.yearAndMonthView.yearLabel.text = "\(updatedYear)"
        calendarHeaderView.yearAndMonthView.monthLabel.text = "\(updatedMonth)월"
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {
    enum Section {
        case previous
        case now
        case next
    }

    enum ScrollDirection {
        case left
        case none
        case right
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = collectionView.bounds.width
        // 임시 사이즈 설정
        let cellHeight = (calendarShape == .month) ? 300 : 50
        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch calendarShape {
        case .month:
            switch scrollDirection {
            case .left:
                viewModel.updatePreviousBaseDate()
                setupCenterXOffset()
            case .none:
                break
            case .right:
                viewModel.updateNextBaseDate()
                setupCenterXOffset()
            }
        case .week:
            switch scrollDirection {
            case .left:
                viewModel.updatePreviousWeekBaseDate()
                setupCenterXOffset()
            case .none:
                break
            case .right:
                viewModel.updateNextWeekBaseDate()
                setupCenterXOffset()
            }
        }
        
        self.calendarCollectionView.reloadData()
    }

    private func updateSnapshot() {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteAllItems()
        snapshot.appendSections([.previous, .now, .next])

        switch calendarShape {
        case .month:
            let days = viewModel.getThreeMonthlyDays()
            snapshot.appendItems([days[0]], toSection: .previous)
            snapshot.appendItems([days[1]], toSection: .now)
            snapshot.appendItems([days[2]], toSection: .next)
        case .week:
            let days = viewModel.getThreeWeeklyDays()
            snapshot.appendItems([days[0]], toSection: .previous)
            snapshot.appendItems([days[1]], toSection: .now)
            snapshot.appendItems([days[2]], toSection: .next)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        switch targetContentOffset.pointee.x {
        case 0:
            scrollDirection = .left
        case self.view.frame.width * 1:
            scrollDirection = .none
        case self.view.frame.width * 2:
            scrollDirection = .right
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let dateCollectionViewCell = cell as? DateCollectionViewCell else {
            return
        }
        if let selectedItems = dateCollectionViewCell.monthlyCollectionView.indexPathsForSelectedItems {
            for indexPath in selectedItems {
                dateCollectionViewCell.monthlyCollectionView.deselectItem(at: indexPath, animated: false)
            }
        }
    }
}

extension CalendarViewController: CellBaseDateChangeDelegate {
    func changeBaseDate(with date: Date) {
        self.calendarAction = .select
        self.viewModel.baseDate.send((date))
    }
}

extension CalendarViewController: CalendarHeaderViewDelegate {
    func scopeSwitchButtonTapped(with scopeType: ScopeType) {
        self.calendarShape = scopeType
        if self.calendarShape == .month {
            self.calendarHeightConstraint.constant = 300
        } else {
            self.calendarHeightConstraint.constant = 50
        }
        
        calendarCollectionView.reloadData()
        updateSnapshot()
        
    }
}

enum ScopeType {
    case month
    case week
}

enum CalendarAction {
    case select
    case none
}
