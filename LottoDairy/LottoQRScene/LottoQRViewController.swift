//
//  LottoQRViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/24.
//

import UIKit
import Combine
import SafariServices

final class LottoQRViewController: UIViewController, LottoQRFlowProtocol {

    var onCameraNotAvailableAlert: ((UIAlertController) -> ())?
    
    var onInvalidAlert: ((UIAlertController) -> ())?

    private lazy var qrReaderView: QRReaderView = {
        let qrReaderView = QRReaderView(frame: view.bounds)
        qrReaderView.delegate = self
        qrReaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return qrReaderView
    }()

    private let viewModel: LottoQRViewModel

    private var qrCodeDidRecognize = PassthroughSubject<String, Never>()

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
            qrCodeDidRecognize: self.qrCodeDidRecognize
        )

        let output = viewModel.transform(from: input)

        output.lottoQRValidation
            .sink { state in
                switch state {
                case .invalid:
                    #if DEBUG
                    print("🆘 로또QR 인식 실패")
                    print("-----------------------------------------")
                    #endif
                    self.showLottoInvalidAlert()
                case .valid(let url):
                    #if DEBUG
                    print("✅ 로또QR 인식 성공! -> 동행복권 결과 페이지 이동")
                    print("✅\(url)")
                    print("-----------------------------------------")
                    #endif
                    // 동행복권 결과 페이지 present
                    self.presentLottoResultView(url)
                }
            }
            .store(in: &cancellables)
    }

    private func presentLottoResultView(_ url: String) {
        guard let url = URL(string: url) else { return }
        let webView: SFSafariViewController = .init(url: url)
        self.present(webView, animated: true, completion: { })
    }
}

extension LottoQRViewController: ReaderViewDelegate {

    func qrCodeDidComplete(_ status: QRStatus) {
        switch status {
        case .success(let lottoURL):
            // QR코드 인식 성공 (not 로또QR)
            self.qrCodeDidRecognize.send(lottoURL)
        case .fail:
            // QR코드 인식 실패
            self.showQRCodeInvalidAlert()
        }

        // 로또 인식 이후 readerView 재시작
        qrReaderView.startSession()
    }
    
    func qrCodeDidFailToSetup(_ error: QRReadingError) {
        print(error)
        self.showCameraNotAvailableAlert()
    }

    private func showQRCodeInvalidAlert() {
        let alert = UIAlertController(
            title: StringLiteral.QRCodeInvalidAlert.title,
            message: StringLiteral.QRCodeInvalidAlert.message,
            preferredStyle: .alert
        )

        let okButton = UIAlertAction(title: StringLiteral.QRCodeInvalidAlert.okTitle, style: .default) { _ in
            self.qrReaderView.startSession()
        }

        alert.addAction(okButton)
        self.onInvalidAlert?(alert)
    }

    private func showCameraNotAvailableAlert() {
        let alert = UIAlertController(
            title: StringLiteral.CameraAlert.title,
            message: StringLiteral.CameraAlert.message,
            preferredStyle: .alert
        )

        let closeButton = UIAlertAction(title: StringLiteral.CameraAlert.closeTitle, style: .default)

        alert.addAction(closeButton)
        self.onCameraNotAvailableAlert?(alert)
    }

    private func showLottoInvalidAlert() {
        let alert = UIAlertController(
            title: StringLiteral.LottoInvalidAlert.title,
            message: StringLiteral.LottoInvalidAlert.message,
            preferredStyle: .alert
        )

        let okButton = UIAlertAction(title: StringLiteral.LottoInvalidAlert.okTitle, style: .default) { _ in
            self.qrReaderView.startSession()
        }

        alert.addAction(okButton)
        self.onInvalidAlert?(alert)
    }
}

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
