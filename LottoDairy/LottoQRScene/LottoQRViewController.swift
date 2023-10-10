//
//  LottoQRViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/24.
//

import UIKit

final class LottoQRViewController: UIViewController, LottoQRFlowProtocol {

    private lazy var qrReaderView: UIView = {
        let qrReaderView = QRReaderView(frame: .zero)
        qrReaderView.delegate = self
        qrReaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return qrReaderView
    }()

    private let viewModel: LottoQRViewModel

    init(viewModel: LottoQRViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }

    private func configureView() {
        view.addSubview(qrReaderView)
    }
}

extension LottoQRViewController: ReaderViewDelegate {

    func lottoQRDidComplete(_ status: QRStatus) {
        print(status)
    }
    
    func lottoQRDidFailToSetup(_ error: QRReadingError) {
        print(error)
    }
}
