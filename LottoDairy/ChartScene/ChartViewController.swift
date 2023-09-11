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

    private let chartView: BarChartView = {
        let chart = BarChartView()
        chart.backgroundColor = .designSystem(.gray2B2C35)
        chart.layer.cornerRadius = 20
        chart.clipsToBounds = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    private var chartViewPublisher = PassthroughSubject<Int, Never>()

    private let dateHeaderView: LottoDiaryTextField = {
        let textField = LottoDiaryTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var datePicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        return picker
    }()

    private lazy var informationCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeInformationListCollectionViewLayout())
        collectionView.register(ChartInformationCell.self)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var dataSource: UICollectionViewDiffableDataSource<ChartInformationComponents.ChartInformationSection, ChartInformationComponents>?

    private let viewModel: ChartViewModel

    private var years: [Int] {
        return viewModel.getYears()
    }
    private var months: [Int] {
        return viewModel.getMonths()
    }

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        self.view.addSubview(chartView)
        chartView.delegate = self
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 280)
        ])

        self.view.addSubview(dateHeaderView)
        NSLayoutConstraint.activate([
            dateHeaderView.topAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 35),
            dateHeaderView.leadingAnchor.constraint(equalTo: self.chartView.leadingAnchor),
            dateHeaderView.trailingAnchor.constraint(equalTo: self.chartView.trailingAnchor)
        ])

        self.view.addSubview(informationCollectionView)
        NSLayoutConstraint.activate([
            informationCollectionView.topAnchor.constraint(equalTo: self.dateHeaderView.bottomAnchor, constant: 15),
            informationCollectionView.leadingAnchor.constraint(equalTo: self.chartView.leadingAnchor),
            informationCollectionView.trailingAnchor.constraint(equalTo: self.chartView.trailingAnchor),
            informationCollectionView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }

    private func configureChartView() {
        self.chartView.setScaleEnabled(false)
        self.chartView.doubleTapToZoomEnabled = false
        self.chartView.legend.enabled = false
        self.chartView.rightAxis.enabled = false
        self.chartView.leftAxis.enabled = false
        self.chartView.xAxis.drawLabelsEnabled = false
        self.chartView.xAxis.drawAxisLineEnabled = false
        self.chartView.xAxis.drawGridLinesEnabled = false
    }

    private func configureInformationCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ChartInformationComponents.ChartInformationSection, ChartInformationComponents>(collectionView: informationCollectionView) { collectionView, indexPath, itemIdentifier in

            let cell: ChartInformationCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: itemIdentifier)
            return cell
        }
        self.informationCollectionView.dataSource = dataSource
    }

    private func updateInformationCollectionViewSnapshot(items: [ChartInformationComponents]) {
        var snapshot = NSDiffableDataSourceSnapshot<ChartInformationComponents.ChartInformationSection, ChartInformationComponents>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot)
    }

    private func makeInformationListCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionNum, env) -> NSCollectionLayoutSection? in
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                       heightDimension: .fractionalHeight(1.0))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 3)
                group.interItemSpacing = .fixed(25)

                let section = NSCollectionLayoutSection(group: group)
                return section
        }
        return layout
    }

    private func configureDateHeaderView() {
        dateHeaderView.inputView = datePicker
        configureToolbar()
    }

    private func configureToolbar() {
        let toolBar = UIToolbar()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))

        toolBar.sizeToFit()
        toolBar.items = [flexibleSpace, doneButton]
        dateHeaderView.inputAccessoryView = toolBar
    }

    @objc
    private func doneButtonTapped() {
        let selectedYear = datePicker.selectedRow(inComponent: 0)
        let selectedMonth = datePicker.selectedRow(inComponent: 1)

        self.dateHeaderView.yearMonthPickerPublisher
            .send([selectedYear, selectedMonth])
        dateHeaderView.resignFirstResponder()
    }

    private func setSelectedRow(year: Int, month: Int) {
        guard let yearIndex = years.firstIndex(of: year),
              let monthIndex = months.firstIndex(of: month) else { return }

        datePicker.selectRow(yearIndex, inComponent: 0, animated: true)
        datePicker.selectRow(monthIndex, inComponent: 1, animated: true)
    }

    private func bindViewModel() {
        let input = ChartViewModel.Input(
            dateHeaderTextFieldDidEditEvent: dateHeaderView.yearMonthPickerPublisher, chartViewDidSelectEvent: chartViewPublisher
        )

        let output = viewModel.transform(from: input)

        output.dateHeaderFieldText
            .sink { [weak self] date in
                self?.dateHeaderView.configureAttributedStringOfYearMonthText(year: date[0], month: date[1])
                self?.setSelectedRow(year: date[0], month: date[1])
            }
            .store(in: &cancellables)

        output.chartView
            .sink { [weak self] barChartData in
                self?.chartView.data = barChartData
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
        return [years, months][component].count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? "\(years[row])년" : "\(months[row])월"
    }
}

extension ChartViewController: ChartViewDelegate {

    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        let selectedMonth = Int(entry.x)
        self.chartViewPublisher.send(selectedMonth)
    }
}
