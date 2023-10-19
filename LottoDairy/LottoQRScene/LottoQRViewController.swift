//
//  LottoQRViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/24.
//

import UIKit
import Combine

final class LottoQRViewController: UIViewController, LottoQRFlowProtocol {

    private lazy var qrReaderView: QRReaderView = {
        let qrReaderView = QRReaderView(frame: view.bounds)
        qrReaderView.delegate = self
        qrReaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return qrReaderView
    }()

    private let viewModel: LottoQRViewModel

    private var lottoQRDidRecognize = PassthroughSubject<String, Never>()

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: LottoQRViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        self.bindViewModel()
    }

    private func configureView() {
        view.addSubview(qrReaderView)
    }

    private func bindViewModel() {
        let input = LottoQRViewModel.Input(
            lottoQRDidRecognize: self.lottoQRDidRecognize
        )

        let output = viewModel.transform(from: input)
    }
}

extension LottoQRViewController: ReaderViewDelegate {

    func lottoQRDidComplete(_ status: QRStatus) {
        print("delegate: \(status)")
    }
    
    func lottoQRDidFailToSetup(_ error: QRReadingError) {
        print(error)
        // 얼럿 띄우고 VC dismiss
    }
}
