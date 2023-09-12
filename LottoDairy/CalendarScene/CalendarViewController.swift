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
        
        setupRootView()
        setupCalendarHeaderView()
        setupCalendarView()
        configureCalendarCollectionViewDataSource()
        self.viewModel.fetchThreeMonthlyDays()
        bindViewModel()
        setupCenterXOffset()
    }

//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        setupCenterXOffset()
//    }
    
    private func setupRootView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .designSystem(.backgroundBlack)
    }
    
    private func setupCalendarHeaderView() {
        calendarHeaderView.delegate = self
        calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(calendarHeaderView)
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarHeaderView.leadingAnchor.constraint(equalTo: safe.leadingAnchor, constant: Constant.calendarHeaderLeading),
            calendarHeaderView.trailingAnchor.constraint(equalTo: safe.trailingAnchor, constant: Constant.calendarHeaderTrailing),
            calendarHeaderView.topAnchor.constraint(equalTo: safe.topAnchor),
            calendarHeaderView.heightAnchor.constraint(equalToConstant: Constant.calendarHeaderHeight),
        ])
    }

    private func setupCalendarView() {
        self.view.addSubview(calendarCollectionView)
        
        calendarHeightConstraint = calendarCollectionView.heightAnchor.constraint(equalToConstant: Constant.monthCalendarHeight)
        
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
            dateCollectionViewCell.configure(
                with: item,
                scope: self.viewModel.calendarShape,
                baseDate: self.viewModel.baseDate
            )
            dateCollectionViewCell.delegate = self
            return dateCollectionViewCell
        }
    }
    
    private func setupCenterXOffset() {
        let width = calendarCollectionView.collectionViewLayout.collectionViewContentSize.width
        guard width != .zero else { return }
        let middleSectionIndex = calendarCollectionView.numberOfSections / 2
        
        let numberOfSections = CGFloat(calendarCollectionView.numberOfSections)
        let middleSectionX = width / numberOfSections * CGFloat(middleSectionIndex)
        calendarCollectionView.setContentOffset(CGPoint(x: middleSectionX, y: 0), animated: false)
    }
    
    private func bindViewModel() {
        viewModel.days
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { days in
                self.updateYearAndMonth(with: self.viewModel.baseDate)
                self.updateSnapshot(with: days)
                self.setupCenterXOffset()
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

    private func updateSnapshot(with days: [[DayComponent]] = []) {
        guard !days.isEmpty else { return }
        var snapshot = NSDiffableDataSourceSnapshot<Section, [DayComponent]>()
        snapshot.appendSections([.previous, .now, .next])

        switch viewModel.calendarShape {
        case .month:
            snapshot.appendItems([days[0]], toSection: .previous)
            snapshot.appendItems([days[1]], toSection: .now)
            snapshot.appendItems([days[2]], toSection: .next)
        case .week:
            snapshot.appendItems([days[0]], toSection: .previous)
            snapshot.appendItems([days[1]], toSection: .now)
            snapshot.appendItems([days[2]], toSection: .next)
        }
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension CalendarViewController: UICollectionViewDelegateFlowLayout {

    private enum Section {
        case previous
        case now
        case next
    }

    private enum ScrollDirection {
        case left
        case none
        case right
    }
    
    private enum CalendarAction {
        case select
        case none
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let cellWidth = collectionView.bounds.width
        let cellHeight = (self.viewModel.calendarShape == .month) ? Constant.monthCalendarHeight : Constant.weekCalendarHeight
        
        return CGSize(width: cellWidth, height: CGFloat(cellHeight))
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch viewModel.calendarShape {
        case .month:
            switch scrollDirection {
            case .left:
                viewModel.updatePreviousBaseDate()
            case .none:
                break
            case .right:
                viewModel.updateNextBaseDate()
            }
        case .week:
            switch scrollDirection {
            case .left:
                viewModel.updatePreviousWeekBaseDate()
            case .none:
                break
            case .right:
                viewModel.updateNextWeekBaseDate()
            }
        }
        self.calendarCollectionView.reloadData()
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
        self.viewModel.changeBaseDate(with: date)
    }
}

extension CalendarViewController: CalendarHeaderViewDelegate {
    func scopeSwitchButtonTapped(with scopeType: ScopeType) {
        self.viewModel.changeCalendarShape()
        if self.viewModel.calendarShape == .month {
            self.calendarHeightConstraint.constant = Constant.monthCalendarHeight
        } else {
            self.calendarHeightConstraint.constant = Constant.weekCalendarHeight
        }
        
        UIView.animate(withDuration: 0.3) {
            self.calendarCollectionView.reloadData()
            self.viewModel.calendarShape == .month ? self.viewModel.fetchThreeMonthlyDays() : self.viewModel.fetchThreeWeeklyDays()
            
            self.view.layoutIfNeeded()
        }
    }
}

extension CalendarViewController {
    private enum Constant {
        static let calendarHeaderLeading: CGFloat = 15
        static let calendarHeaderTrailing: CGFloat = -15
        static let calendarHeaderHeight: CGFloat = 100
        static let monthCalendarHeight: CGFloat = 300
        static let weekCalendarHeight: CGFloat = 50
    }
}
