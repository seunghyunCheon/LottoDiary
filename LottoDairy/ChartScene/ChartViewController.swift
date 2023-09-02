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

    private let informationListCollectionView: UICollectionView = {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChartInformationCell.self)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.setupChartView()
        self.configureChartView()
        self.setupInformationListCollectionView()
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
            informationListCollectionView.heightAnchor.constraint(equalToConstant: 260)
        ])
    }

}
