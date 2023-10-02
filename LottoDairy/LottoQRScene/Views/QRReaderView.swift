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

    private var rectOfInterest: CGRect?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupRectOfInterest()

        configureSessionInput()
        configureSessionOutput()

        configurePreviewLayer()
        configureRectOfInterest()

        start()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupRectOfInterest() {
        let size = self.frame.height * 0.28
        let halfOfWidth = bounds.width / 2
        let halfOfHeight = bounds.height / 2

        self.rectOfInterest = CGRect(
            x: halfOfWidth - (size / 2),
            y: halfOfHeight - (size / 2),
            width: size,
            height: size
        )
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
        let output = AVCaptureMetadataOutput()
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
        let path = createCorner()

        // CAShapeLayer를 생성하고 설정
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = Constant.cornerLineWidth
        shapeLayer.lineCap = .square

        // CAShapeLayer에 경로를 설정하고 미리보기 레이어에 추가
        self.previewLayer?.addSublayer(shapeLayer)
    }

    private func createCorner() -> CGMutablePath {
        guard let rectOfInterest = rectOfInterest else { return CGMutablePath() }

        let halfOfCornerLineWidth = Constant.cornerLineWidth / 2
        let topLeftPoint = CGPoint(x: rectOfInterest.minX - halfOfCornerLineWidth, y: rectOfInterest.minY - halfOfCornerLineWidth)
        let topRightPoint = CGPoint(x: rectOfInterest.maxX + halfOfCornerLineWidth, y: rectOfInterest.minY - halfOfCornerLineWidth)
        let bottomRightPoint = CGPoint(x: rectOfInterest.maxX + halfOfCornerLineWidth, y: rectOfInterest.maxY + halfOfCornerLineWidth)
        let bottomLeftPoint = CGPoint(x: rectOfInterest.minX - halfOfCornerLineWidth, y: rectOfInterest.maxY + halfOfCornerLineWidth)

        let cornerRadius = min(previewLayer?.cornerRadius ?? 0, Constant.cornerLength)
        let cornerLength = min(rectOfInterest.width / 2, Constant.cornerLength)

        let topLeftCorner = UIBezierPath()
        topLeftCorner.move(to: topLeftPoint.offsetBy(dx: 0, dy: cornerLength))
        topLeftCorner.addArc(
            withCenter: topLeftPoint.offsetBy(dx: cornerRadius, dy: cornerRadius),
            radius: cornerRadius,
            startAngle: .pi,
            endAngle: 3 * .pi / 2,
            clockwise: true
        )
        topLeftCorner.addLine(to: topLeftPoint.offsetBy(dx: cornerLength, dy: 0))

        let topRightCorner = UIBezierPath()
        topRightCorner.move(to: topRightPoint.offsetBy(dx: -cornerLength, dy: 0))
        topRightCorner.addArc(
            withCenter: topRightPoint.offsetBy(dx: -cornerRadius, dy: cornerRadius),
            radius: cornerRadius,
            startAngle: 3 * .pi / 2,
            endAngle: 0,
            clockwise: true
        )
        topRightCorner.addLine(to: topRightPoint.offsetBy(dx: 0, dy: cornerLength))

        let bottomRightCorner = UIBezierPath()
        bottomRightCorner.move(to: bottomRightPoint.offsetBy(dx: 0, dy: -cornerLength))
        bottomRightCorner.addArc(
            withCenter: bottomRightPoint.offsetBy(dx: -cornerRadius, dy: -cornerRadius),
            radius: cornerRadius,
            startAngle: 0,
            endAngle: .pi / 2,
            clockwise: true
        )
        bottomRightCorner.addLine(to: bottomRightPoint.offsetBy(dx: -cornerLength, dy: 0))

        let bottomLeftCorner = UIBezierPath()
        bottomLeftCorner.move(to: bottomLeftPoint.offsetBy(dx: cornerLength, dy: 0))
        bottomLeftCorner.addArc(
            withCenter: bottomLeftPoint.offsetBy(dx: cornerRadius, dy: -cornerRadius),
            radius: cornerRadius,
            startAngle: .pi / 2,
            endAngle: .pi,
            clockwise: true
        )
        bottomLeftCorner.addLine(to: bottomLeftPoint.offsetBy(dx: 0, dy: -cornerLength))

        let mutablePath = CGMutablePath()
        mutablePath.addPath(topLeftCorner.cgPath)
        mutablePath.addPath(topRightCorner.cgPath)
        mutablePath.addPath(bottomRightCorner.cgPath)
        mutablePath.addPath(bottomLeftCorner.cgPath)

        return mutablePath
    }

    private func createShapeLayer() -> CAShapeLayer {
        let layer = CAShapeLayer()
        guard let rectOfInterest = rectOfInterest else { return layer }

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
//        guard let previewLayer = previewLayer else { return }
//        output?.rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
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

extension QRReaderView {

    private enum Constant {
        static let cornerLength: CGFloat = 20
        static let cornerLineWidth: CGFloat = 6
    }
}

internal extension CGPoint {

    // MARK: - CGPoint+offsetBy
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
