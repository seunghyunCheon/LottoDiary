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
extension LottoQRViewController {

    private enum StringLiteral {

        enum CameraAlert {
            static let title = "카메라를 사용할 수 없어요."
            static let message = "잠시후 다시 시도해 주세요."
            static let closeTitle = "닫기"
        }

        enum LottoInvalidAlert {
            static let title = "유효한 로또 QR가 아니에요."
            static let message = "로또 QR코드가 맞는지 확인해주세요."
            static let okTitle = "확인"
        }

        enum QRCodeInvalidAlert {
            static let title = "QR코드 인식에 실패했어요."
            static let message = "올바른 QR코드가 맞는지 확인해주세요."
            static let okTitle = "확인"
        }
    }
}
