//
//  QRReaderView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/10/02.
//

import UIKit
import AVFoundation

enum QRStatus {
    case success(_ code: String?)
    case fail
    case stop(_ isButtonTap: Bool)
}

protocol ReaderViewDelegate: AnyObject {
    func lottoQRDidComplete(_ status: QRStatus)
}

final class QRReaderView: UIView {

    weak var delegate: ReaderViewDelegate?

    private var session: AVCaptureSession?

    private var previewLayer: AVCaptureVideoPreviewLayer?

    private var output: AVCaptureMetadataOutput?

    private var rectOfInterest: CGRect {
        CGRect(
            x: (Int(bounds.width) / 2) - (200 / 2),
            y: (Int(bounds.width) / 2) - (200 / 2),
            width: 200,
            height: 200
        )
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureSessionInput()
        configureSessionOutput()

        configurePreviewLayer()
        configureRectOfInterest()

        start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureSessionInput() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }

        self.session = AVCaptureSession()
        guard let session = self.session else { return }

        let input: AVCaptureInput

        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error {
            print(error.localizedDescription)
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            print("session input 오류")
            return
        }
    }

    private func configureSessionOutput() {
        self.output = AVCaptureMetadataOutput()
        guard let output = self.output else { return }
        guard let session = self.session else { return }

        if session.canAddOutput(output) {
            session.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]
        } else {
            print("session output 오류")
            return
        }
    }

    private func configurePreviewLayer() {
        guard let session = session else { return }
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)

        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = self.layer.bounds

        let layer = createShapeLayer()
        previewLayer.addSublayer(layer)

        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer
    }

    private func configureRectOfInterest() {

    }

    private func createShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()

        let path = CGMutablePath()
        // 하나의 큰 사각형 추가
        path.addRect(bounds)
        // QR코드 인식을 위한 가운데 작은 사각형 추가
        path.addRect(rectOfInterest)
        
        layer.path = path
        layer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        layer.fillRule = .evenOdd

        return layer
    }

    private func start() {
        DispatchQueue.global().async {
            self.session?.startRunning()
        }

        // AVCaptureSession에서 CGRect 만큼 인식 구역으로 지정함.
//        output?.rectOfInterest = previewLayer!.metadataOutputRectConverted(fromLayerRect: self.rectOfInterest)
    }
}

// AVCaptureMetadataOutputObjectsDelegate : 사진 캡쳐 output으로 인해 생성된 메타데이터를 받는 방법
// 캡쳐를 통해 메타데이터를 인식하면 델리게이트 실행
extension QRReaderView: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        print("메타 데이터 output 받았습니다. delegate 실행 ~")

        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else {
                print("delegate 오류!!!!")
                return
            }

            print(stringValue)

            self.delegate?.lottoQRDidComplete(.success(stringValue))
            self.delegate?.lottoQRDidComplete(.stop(true))
        }
    }

}
