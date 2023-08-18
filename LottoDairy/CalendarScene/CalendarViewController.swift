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
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
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
        setupCalendarHeaderView()
        setupCalendarView()
        configureCalendarCollectionViewDataSource()
        configureSnapshot()
        setupCenterXOffset()
        bindViewModel()
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
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            calendarCollectionView.topAnchor.constraint(equalTo: calendarHeaderView.bottomAnchor),
            calendarCollectionView.heightAnchor.constraint(equalToConstant: 300),
        ])
    }

    private func configureCalendarCollectionViewDataSource() {
        self.dataSource = UICollectionViewDiffableDataSource<Section, [DayComponent]>(
            collectionView: self.calendarCollectionView
        ) { collectionView, indexPath, item in
            let dateCollectionViewCell: DateCollectionViewCell = collectionView.dequeue(for: indexPath)
            dateCollectionViewCell.configure(with: item)
            return dateCollectionViewCell
        }
    }

    private func configureSnapshot() {
        let threeMonthlyDays = viewModel.getThreeMonthlyDays()

        var snapshot = NSDiffableDataSourceSnapshot<Section, [DayComponent]>()
        snapshot.appendSections([.previous, .now, .next])
        snapshot.appendItems([threeMonthlyDays[0]], toSection: .previous)
        snapshot.appendItems([threeMonthlyDays[1]], toSection: .now)
        snapshot.appendItems([threeMonthlyDays[2]], toSection: .next)
        self.dataSource?.apply(snapshot)
    }

    @discardableResult
    private func setupCenterXOffset() -> CGFloat {
        let middleSectionIndex = calendarCollectionView.numberOfSections / 2
        let width = calendarCollectionView.collectionViewLayout.collectionViewContentSize.width
        let numberOfSections = CGFloat(calendarCollectionView.numberOfSections)
        let middleSectionX = width / numberOfSections * CGFloat(middleSectionIndex)
        calendarCollectionView.setContentOffset(CGPoint(x: middleSectionX, y: 0), animated: false)

        return middleSectionX
    }
    
    private func bindViewModel() {
        viewModel.baseDate
            .sink { _ in
                self.updateSnapshot()
            }
            .store(in: &cancellables)
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
        return CGSize(width: cellWidth, height: 300)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
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
    }

    private func updateSnapshot() {
        guard var snapshot = dataSource?.snapshot() else { return }
        snapshot.deleteAllItems()

        snapshot.appendSections([.previous, .now, .next])
        let days = viewModel.getThreeMonthlyDays()
        snapshot.appendItems([days[0]], toSection: .previous)
        snapshot.appendItems([days[1]], toSection: .now)
        snapshot.appendItems([days[2]], toSection: .next)
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
}
