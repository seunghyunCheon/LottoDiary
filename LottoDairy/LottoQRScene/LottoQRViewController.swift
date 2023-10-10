//
//  LottoQRViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/24.
//

import UIKit
import AVFoundation

final class LottoQRViewController: UIViewController, LottoQRFlowProtocol {

    private lazy var qrReaderView: QRReaderView = {
        let qrReaderView = QRReaderView(frame: view.bounds)
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
        requestCameraPermission()
    }

    private func configureView() {
        view.addSubview(qrReaderView)
    }

    private func requestCameraPermission() {
        let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)

        switch cameraAuthorizationStatus {
        case .notDetermined:
            self.requestCameraAccess()
        case .restricted, .denied:
            print("no2")
        case .authorized:
            qrReaderView.start()
        @unknown default:
            break
        }
    }

    private func requestCameraAccess() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            if granted {
                print("권한 설정 완료")
                self?.qrReaderView.start()
            } else {
                print("권한 설정 완료 X")
            }
        }
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
