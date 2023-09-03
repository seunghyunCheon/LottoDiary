//
//  ChartViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/08/27.
//

import UIKit
import DGCharts

final class ChartViewController: UIViewController, ChartFlowProtocol {

    private let chartView: BarChartView = {
        let chart = BarChartView()
        chart.backgroundColor = .designSystem(.gray2B2C35)
        chart.layer.cornerRadius = 20
        chart.clipsToBounds = true
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    private let dateHeaderView: UITextField = {
        let textField = UITextField()
        textField.text = "hi"
        textField.font = .gmarketSans(size: .title3, weight: .bold)
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var informationCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: makeInformationListCollectionViewLayout())
        collectionView.register(ChartInformationCell.self)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private var dataSource: UICollectionViewDiffableDataSource<ChartInformationSection, ChartInformationComponents>?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.setupView()

        self.configureChartView()

        self.configureInformationCollectionViewDataSource()
        self.updateInformationCollectionViewSnapshot()
    }

    private func configureView() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .designSystem(.backgroundBlack)
    }

    private func setupView() {
        self.view.addSubview(chartView)
//        chartView.delegate = self
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chartView.heightAnchor.constraint(equalToConstant: 280)
        ])

        self.view.addSubview(dateHeaderView)
        self.dateHeaderView.delegate = self
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
        dataSource = UICollectionViewDiffableDataSource<ChartInformationSection, ChartInformationComponents>(collectionView: informationCollectionView) { collectionView, indexPath, itemIdentifier in

            let cell: ChartInformationCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: itemIdentifier)
            return cell
        }
        self.informationCollectionView.dataSource = dataSource
    }

    private func updateInformationCollectionViewSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<ChartInformationSection, ChartInformationComponents>()
        snapshot.appendSections([.main])
        snapshot.appendItems(ChartInformationComponents.mock)
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
//                section.interGroupSpacing = 20
                return section
        }
        return layout
    }

}

extension ChartViewController: UITextFieldDelegate {
    
}
