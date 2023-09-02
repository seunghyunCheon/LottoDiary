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

    private lazy var informationListCollectionView: UICollectionView = {
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
        self.setupChartView()
        self.configureChartView()

        self.setupInformationListCollectionView()
        self.configureInformationListCollectionViewDataSource()
        self.updateInformationListCollectionViewSnapshot()
    }

    private func configureView() {
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = .designSystem(.backgroundBlack)
    }

    private func setupChartView() {
        self.view.addSubview(chartView)
//        chartView.delegate = self

        NSLayoutConstraint.activate([
            self.chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            self.chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.chartView.heightAnchor.constraint(equalToConstant: 280)
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

    private func setupInformationListCollectionView() {
        self.view.addSubview(informationListCollectionView)

        NSLayoutConstraint.activate([
            informationListCollectionView.topAnchor.constraint(equalTo: self.chartView.bottomAnchor, constant: 30),
            informationListCollectionView.leadingAnchor.constraint(equalTo: self.chartView.leadingAnchor),
            informationListCollectionView.trailingAnchor.constraint(equalTo: self.chartView.trailingAnchor),
            informationListCollectionView.heightAnchor.constraint(equalToConstant: 210)
        ])
    }

    private func configureInformationListCollectionViewDataSource() {
        dataSource = UICollectionViewDiffableDataSource<ChartInformationSection, ChartInformationComponents>(collectionView: informationListCollectionView) { collectionView, indexPath, itemIdentifier in

            let cell: ChartInformationCell = collectionView.dequeue(for: indexPath)
            cell.configure(with: itemIdentifier)
            return cell
        }
        self.informationListCollectionView.dataSource = dataSource
    }

    private func updateInformationListCollectionViewSnapshot() {
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
