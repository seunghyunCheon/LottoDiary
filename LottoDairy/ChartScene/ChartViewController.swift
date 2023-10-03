//
//  ChartViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/27.
//

import UIKit
import DGCharts
import Combine

final class ChartViewController: UIViewController, ChartFlowProtocol {

    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .designSystem(.gray2B2C35)
        view.layer.cornerRadius = Constant.cornerRadius
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let chartView: BarChartView = {
        let chart = BarChartView()
        chart.backgroundColor = .clear
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    private let chartEmptyLabel: UIImageView = {
        let label = UIImageView(image: Image.emptyChart.image)
        label.contentMode = .scaleAspectFit
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let dateHeaderView: LottoDiaryTextField = {
        let textField = LottoDiaryTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let chartTitleLabel: UILabel = {
        let label = GmarketSansLabel(
            text: StringLiteral.chartTitle,
            color: .designSystem(.grayA09FA7) ?? .gray,
            alignment: .left, 
            size: .title3,
            weight: .bold
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var datePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    private lazy var informationCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: makeInformationListCollectionViewLayout()
        )
        collectionView.register(ChartInformationCell.self)
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var dataSource: UICollectionViewDiffableDataSource<ChartInformationSection, ChartInformationComponents>?

    private let viewModel: ChartViewModel

    private var chartViewPublisher = PassthroughSubject<Int, Never>()

    private var viewWillAppearPublisher = PassthroughSubject<Void, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewWillAppearPublisher.send()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.setupView()

        self.configureChartView()
        self.configureInformationCollectionViewDataSource()
        self.configureDateHeaderView()

        self.bindViewModel()
    }

    private func configureView() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .designSystem(.backgroundBlack)
    }

    private func setupView() {
        self.view.addSubview(chartTitleLabel)
        let chartTitleLeading: CGFloat = Device.Constraint.horiziontal + 10
        NSLayoutConstraint.activate([
            chartTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartTitleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: chartTitleLeading
            )
        ])

        self.view.addSubview(backgroundView)
        let backgroundViewHeight = view.frame.height * 0.33
        let backgroundViewTop: CGFloat = view.frame.height * 0.015
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(
                equalTo: self.chartTitleLabel.bottomAnchor,
                constant: backgroundViewTop
            ),
            backgroundView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Device.Constraint.horiziontal
            ),
            backgroundView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -Device.Constraint.horiziontal
            ),
            backgroundView.heightAnchor.constraint(equalToConstant: backgroundViewHeight)
        ])

        self.backgroundView.addSubview(chartView)
        self.chartView.delegate = self
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: self.backgroundView.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor, constant: Constant.chartViewMargin),
            chartView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor, constant: -Constant.chartViewMargin),
            chartView.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: -Constant.chartViewMargin)
        ])

        self.view.addSubview(chartEmptyLabel)
        NSLayoutConstraint.activate([
            chartEmptyLabel.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor),
            chartEmptyLabel.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor),
            chartEmptyLabel.topAnchor.constraint(equalTo: self.backgroundView.topAnchor),
            chartEmptyLabel.bottomAnchor.constraint(equalTo: self.backgroundView.bottomAnchor)
        ])

        self.view.addSubview(dateHeaderView)
        let dateHeaderViewTop: CGFloat = view.frame.height * 0.041
        NSLayoutConstraint.activate([
            dateHeaderView.topAnchor.constraint(
                equalTo: self.backgroundView.bottomAnchor,
                constant: dateHeaderViewTop
            ),
            dateHeaderView.leadingAnchor.constraint(equalTo: self.backgroundView.leadingAnchor),
            dateHeaderView.trailingAnchor.constraint(equalTo: self.backgroundView.trailingAnchor)
        ])

        self.view.addSubview(informationCollectionView)
        let informationCollectionViewTop: CGFloat = view.frame.height * 0.018
        let informationCollectionViewHeight: CGFloat = view.frame.height * 0.249
        NSLayoutConstraint.activate([
            informationCollectionView.topAnchor.constraint(
                equalTo: self.dateHeaderView.bottomAnchor,
                constant: informationCollectionViewTop
            ),
            informationCollectionView.leadingAnchor.constraint(
                equalTo: self.backgroundView.leadingAnchor
            ),
            informationCollectionView.trailingAnchor.constraint(
                equalTo: self.backgroundView.trailingAnchor
            ),
            informationCollectionView.heightAnchor.constraint(
                equalToConstant: informationCollectionViewHeight
            )
        ])
    }

    private func configureChartView() {
        self.chartView.setScaleEnabled(false)
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.legend.enabled = false

        configureLeftAxis(self.chartView.leftAxis)
        configureRightAxis(self.chartView.rightAxis)
        configureXAxis(self.chartView.xAxis)
    }

    private func configureRightAxis(_ rightAxis: YAxis) {
        rightAxis.drawLabelsEnabled = false
        rightAxis.drawGridLinesEnabled = false
        rightAxis.drawAxisLineEnabled = false
    }

    private func configureLeftAxis(_ leftAxis: YAxis) {
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawGridLinesEnabled = false
        leftAxis.drawAxisLineEnabled = false

        leftAxis.drawZeroLineEnabled = true
        leftAxis.zeroLineWidth = 2
        leftAxis.zeroLineColor = .designSystem(.mainBlue)
    }

    private func configureXAxis(_ xAxis: XAxis) {
        var monthlyText = viewModel.months.map { "\($0)월" }
        monthlyText.insert("", at: 0)
        xAxis.valueFormatter = IndexAxisValueFormatter(values: monthlyText)

        xAxis.labelFont = .gmarketSans(size: .caption, weight: .medium)
        xAxis.labelPosition = .bottom
        xAxis.labelTextColor = .white
        xAxis.labelCount = 4

        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
    }

    private func configureInformationCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ChartInformationSection, ChartInformationComponents>(
                                                                collectionView: informationCollectionView
        ) { collectionView, indexPath, itemIdentifier in
            let cell: ChartInformationCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: itemIdentifier)

            return cell
        }
        self.informationCollectionView.dataSource = dataSource
    }

    private func updateInformationCollectionViewSnapshot(items: [ChartInformationComponents]) {
        var snapshot = NSDiffableDataSourceSnapshot<ChartInformationSection, ChartInformationComponents>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        self.dataSource?.apply(snapshot)
    }

    private func makeInformationListCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNum, env) -> NSCollectionLayoutSection? in
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 3
                )
                group.interItemSpacing = .fixed(Constant.interItemSpacing)

                let section = NSCollectionLayoutSection(group: group)
                return section
        }

        return layout
    }

    private func configureDateHeaderView() {
        self.dateHeaderView.inputView = datePicker
        self.configureToolbar()
    }

    private func configureToolbar() {
        let toolBar = UIToolbar()

        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )

        toolBar.sizeToFit()
        toolBar.items = [flexibleSpace, doneButton]
        self.dateHeaderView.inputAccessoryView = toolBar
    }

    @objc
    private func doneButtonTapped() {
        let selectedYear = datePicker.selectedRow(inComponent: 0)
        let selectedMonth = datePicker.selectedRow(inComponent: 1)

        self.dateHeaderView.yearMonthPickerPublisher
            .send([selectedYear, selectedMonth])
        self.dateHeaderView.resignFirstResponder()
    }

    private func setSelectedRow(year: Int, month: Int) {
        guard let yearIndex = viewModel.years.firstIndex(of: year),
              let monthIndex = viewModel.months.firstIndex(of: month) else { return }

        self.datePicker.selectRow(yearIndex, inComponent: 0, animated: true)
        self.datePicker.selectRow(monthIndex, inComponent: 1, animated: true)
    }

    private func bindViewModel() {
        let input = ChartViewModel.Input(
            viewWillAppearEvent: self.viewWillAppearPublisher,
            dateHeaderTextFieldDidEditEvent: dateHeaderView.yearMonthPickerPublisher,
            chartViewDidSelectEvent: chartViewPublisher
        )

        let output = viewModel.transform(from: input)

        output.chartView
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print(error)
                }
            }, receiveValue: { [weak self] barChartData in
                guard let first = barChartData.dataSets.first else { return }
                if barChartData.entryCount == .zero {
                    self?.chartEmptyLabel.isHidden = false
                    self?.chartView.isHidden = true
                } else {
                    self?.chartEmptyLabel.isHidden = true
                    self?.chartView.isHidden = false
                    self?.chartView.data = barChartData
                }
            })
            .store(in: &cancellables)

        output.dateHeaderFieldText
            .sink { [weak self] date in
                self?.dateHeaderView.configureAttributedStringOfYearMonthText(
                    year: date[0],
                    month: date[1]
                )
                self?.setSelectedRow(year: date[0], month: date[1])
                self?.chartView.highlightValue(x: Double(date[1]), dataSetIndex: 0)
            }
            .store(in: &cancellables)

        output.chartInformationCollectionView
            .sink { [weak self] items in
                self?.updateInformationCollectionViewSnapshot(items: items)
            }
            .store(in: &cancellables)
    }
}

extension ChartViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return [viewModel.years, viewModel.months][component].count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return component == 0 ? "\(viewModel.years[row])년" : "\(viewModel.months[row])월"
    }
}

extension ChartViewController: ChartViewDelegate {

    func chartValueSelected(
        _ chartView: ChartViewBase,
        entry: ChartDataEntry,
        highlight: Highlight
    ) {
        let selectedMonth = Int(entry.x)
        self.chartViewPublisher.send(selectedMonth)
    }
}

extension ChartViewController {

    private enum Image: String {
        case emptyChart = "차트안내메세지"

        var image: UIImage? {
            return UIImage(named: self.rawValue)
        }
    }

    private enum Constant {
        static let cornerRadius: CGFloat = 20
        static let interItemSpacing: CGFloat = 25
        static let chartViewMargin: CGFloat = 10
    }

    private enum StringLiteral {
        static let chartTitle = "소비 분석"
    }
}
