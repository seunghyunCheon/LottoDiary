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
    
    private lazy var lottoCollectionView: UICollectionView = {
        let layout = LottoCollectionViewLayout().createLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .designSystem(.backgroundBlack)
        collectionView.isScrollEnabled = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var onAddLotto: ((Date) -> Void)?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, [DayComponent]>?

    private var lottoDataSource: UICollectionViewDiffableDataSource<Int, Lotto>!
    
    private var scrollDirection: ScrollDirection = .none

    private let viewModel: CalendarViewModel
    
    private var cancellables = Set<AnyCancellable>()
    
    private var calendarAction: CalendarAction = .none
    private var calendarHeightConstraint: NSLayoutConstraint!
    private var lottosHeightConstraint: NSLayoutConstraint!
    
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
        setupScrollView()
        setupCalendarHeaderView()
        setupCalendarView()
        setupLottoCollectionView()
        configureCalendarCollectionViewDataSource()
        configureLottoCollectionViewDataSource()
        self.viewModel.fetchThreeMonthlyDays()
        bindViewModel()
        setupCenterXOffset()
    }
    
    func addLotto() {
        if viewModel.calendarShape == .month {
            viewModel.fetchThreeMonthlyDays()
        } else {
            viewModel.fetchThreeWeeklyDays()
        }
    }
    
    // MARK: - Private Methods
    
    private func setupRootView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.backgroundColor = .designSystem(.backgroundBlack)
    }
    
    private func setupScrollView() {
        self.view.addSubview(self.scrollView)
        
        let safe = view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            self.scrollView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: safe.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        
        scrollView.addSubview(self.contentView)
        
        NSLayoutConstraint.activate([
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.trailingAnchor),
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.topAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor),
            
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.frameLayoutGuide.widthAnchor),
        ])
    }
    
    private func setupCalendarHeaderView() {
        calendarHeaderView.delegate = self
        calendarHeaderView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(calendarHeaderView)

        NSLayoutConstraint.activate([
            calendarHeaderView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: Constant.calendarHeaderLeading),
            calendarHeaderView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: Constant.calendarHeaderTrailing),
            calendarHeaderView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            calendarHeaderView.heightAnchor.constraint(equalToConstant: Constant.calendarHeaderHeight),
        ])
    }

    private func setupCalendarView() {
        self.contentView.addSubview(calendarCollectionView)
        
        calendarHeightConstraint = calendarCollectionView.heightAnchor.constraint(equalToConstant: Constant.monthCalendarHeight)
        
        let safe = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            calendarCollectionView.leadingAnchor.constraint(equalTo: safe.leadingAnchor),
            calendarCollectionView.trailingAnchor.constraint(equalTo: safe.trailingAnchor),
            calendarCollectionView.topAnchor.constraint(equalTo: self.calendarHeaderView.bottomAnchor),
            calendarHeightConstraint
        ])
    }
    
    private func setupLottoCollectionView() {
        self.lottoCollectionView.register(LottoCell.self, forCellWithReuseIdentifier: LottoCell.identifer)
        self.contentView.addSubview(lottoCollectionView)
        
        lottosHeightConstraint = self.lottoCollectionView.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            self.lottoCollectionView.topAnchor.constraint(equalTo: self.calendarCollectionView.bottomAnchor, constant: 0),
            self.lottoCollectionView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.lottoCollectionView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.lottoCollectionView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            lottosHeightConstraint,
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
                baseDate: self.viewModel.baseDate.value
            )
            dateCollectionViewCell.delegate = self
            return dateCollectionViewCell
        }
    }
    
    private func configureLottoCollectionViewDataSource() {
        lottoDataSource = UICollectionViewDiffableDataSource<Int, Lotto>(collectionView: self.lottoCollectionView) {
            collectionView, indexPath, item in
            let lottoCell: LottoCell = collectionView.dequeue(for: indexPath)
            lottoCell.configure(with: item)
            
            return lottoCell
        }
        
        let footerRegistration = UICollectionView.SupplementaryRegistration(
            elementKind: AddLottoFooterView.elementKind,
            handler: footerRegistrationHandler)
        
        lottoDataSource.supplementaryViewProvider = {
            (collectionView, elementKind, indexPath) -> UICollectionReusableView? in
                return collectionView.dequeueConfiguredReusableSupplementary(
                    using: footerRegistration, for: indexPath)
        }
        
        lottoCollectionView.dataSource = lottoDataSource
    }
    
    private func footerRegistrationHandler(addLottoFooterView: AddLottoFooterView, elementKind: String, indexPath: IndexPath) {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.didPressAddButton))
        addLottoFooterView.addGestureRecognizer(gesture)
    }
    
    @objc
    func didPressAddButton(sender: UITapGestureRecognizer) {
        self.onAddLotto?(self.viewModel.baseDate.value)
    }
    
    private func bindViewModel() {
        // 스크롤, 주간/월간 변경 시 업데이트
        viewModel.days
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] days in
                guard let self else { return }
                self.updateYearAndMonth(with: self.viewModel.baseDate.value)
                self.updateSnapshot(with: days)
                self.setupCenterXOffset()
                let lottos = self.updateLottoLayout(with: self.viewModel.baseDate.value)
                self.updateLottoSnapshot(with: lottos)
            }
            .store(in: &cancellables)
        
        // 날짜 클릭 시 업데이트
        viewModel.baseDate
            .sink { [weak self] date in
                if self?.calendarAction == .select {
                    let lottos = self?.updateLottoLayout(with: date)
                    self?.updateLottoSnapshot(with: lottos ?? [])
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupCenterXOffset() {
        let width = calendarCollectionView.collectionViewLayout.collectionViewContentSize.width
        guard width != .zero else { return }
        let middleSectionIndex = calendarCollectionView.numberOfSections / 2
        
        let numberOfSections = CGFloat(calendarCollectionView.numberOfSections)
        let middleSectionX = width / numberOfSections * CGFloat(middleSectionIndex)
        calendarCollectionView.setContentOffset(CGPoint(x: middleSectionX, y: 0), animated: false)
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
    
    private func updateLottoLayout(with date: Date) -> [Lotto] {
        let dayComponents = viewModel.days.value
        guard !dayComponents.isEmpty else {
            return []
        }
        
        let filteredDate = dayComponents.flatMap { $0 }.filter { $0.date.equalsDate(with: date) }
    
        let lottos = filteredDate[0].lottos
        
        lottosHeightConstraint.constant = CGFloat(CGFloat(lottos.count) * Constant.lottoCellHeight + Constant.lottoFooterHeight)
        self.lottoCollectionView.reloadData()

        return lottos
    }
    
    private func updateLottoSnapshot(with lottos: [Lotto]) {
        var snapshot = lottoDataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        
        snapshot.appendItems(lottos, toSection: 0)
        lottoDataSource.apply(snapshot, animatingDifferences: true)
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
        self.calendarAction = .none
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
            self.viewModel.calendarShape == .month ?
            self.viewModel.fetchThreeMonthlyDays() :
            self.viewModel.fetchThreeWeeklyDays()
            
            self.view.layoutIfNeeded()
        }
    }
}

extension CalendarViewController {
    private enum Constant {
        static let calendarHeaderLeading: CGFloat = 15
        static let calendarHeaderTrailing: CGFloat = -15
        static let calendarHeaderHeight: CGFloat = 100
        static let monthCalendarHeight: CGFloat = 250
        static let weekCalendarHeight: CGFloat = 50
        static let lottoCellHeight: CGFloat = 105
        static let lottoFooterHeight: CGFloat = 100
    }
    
    private enum CalendarAction {
        case select
        case none
    }
}
