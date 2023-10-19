//
//  QRReaderView.swift
//  LottoDairy
//
//  Created by Sunny on 2023/10/02.
//

import UIKit
import AVFoundation

enum QRStatus {
    case success(_ code: String)
    case fail
}

enum QRReadingError: Error {
    case failedToProvideCaptureDeviceInput
    case failedToAddCaptureDeviceInput
    case failedToAddCaptureMetadataOutput
    case failedToCaptureSession
}

protocol ReaderViewDelegate: AnyObject {
    func qrCodeDidComplete(_ status: QRStatus)
    func qrCodeDidFailToSetup(_ error: QRReadingError)
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

        configureRectOfInterest()

        startSession()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func startSession() {
        DispatchQueue.global().async {
            self.session?.startRunning()
        }
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
        } catch {
            delegate?.qrCodeDidFailToSetup(QRReadingError.failedToProvideCaptureDeviceInput)
            return
        }

        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            delegate?.qrCodeDidFailToSetup(QRReadingError.failedToAddCaptureDeviceInput)
            return
        }
    }

    private func configureSessionOutput() {
        guard let session = self.session else {
            delegate?.qrCodeDidFailToSetup(QRReadingError.failedToCaptureSession)
            return
        }
        let output = AVCaptureMetadataOutput()

        if session.canAddOutput(output) {
            session.addOutput(output)

            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [.qr]

            let previewLayer = createPreviewLayer()
            output.rectOfInterest = previewLayer
        } else {
            delegate?.qrCodeDidFailToSetup(QRReadingError.failedToAddCaptureMetadataOutput)
            return
        }
    }

    private func createPreviewLayer() -> CGRect {
        guard let session = session,
              let rectOfInterest = rectOfInterest else { return CGRect() }
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)

        previewLayer.frame = self.layer.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill

        let layer = createShapeLayer()
        previewLayer.addSublayer(layer)

        self.layer.addSublayer(previewLayer)
        self.previewLayer = previewLayer

        return previewLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }

    private func configureRectOfInterest() {
        let path = createCorner()

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = Constant.cornerLineWidth
        shapeLayer.lineCap = .square

        self.previewLayer?.addSublayer(shapeLayer)
    }

    private func createCorner() -> CGMutablePath {
        guard let rectOfInterest = rectOfInterest else { return CGMutablePath() }

        let halfOfCornerLineWidth = Constant.cornerLineWidth / 2
        let topLeftPoint = CGPoint(x: rectOfInterest.minX - halfOfCornerLineWidth, y: rectOfInterest.minY - halfOfCornerLineWidth)
        let topRightPoint = CGPoint(x: rectOfInterest.maxX + halfOfCornerLineWidth, y: rectOfInterest.minY - halfOfCornerLineWidth)
        let bottomRightPoint = CGPoint(x: rectOfInterest.maxX + halfOfCornerLineWidth, y: rectOfInterest.maxY + halfOfCornerLineWidth)
        let bottomLeftPoint = CGPoint(x: rectOfInterest.minX - halfOfCornerLineWidth, y: rectOfInterest.maxY + halfOfCornerLineWidth)

        let topLeftCorner = createCorner(
            movePoint: topLeftPoint.offsetBy(dx: 0, dy: Constant.cornerLength),
            withCenter: topLeftPoint,
            addLinePoint: topLeftPoint.offsetBy(dx: Constant.cornerLength, dy: 0)
        )

        let topRightCorner = createCorner(
            movePoint: topRightPoint.offsetBy(dx: -Constant.cornerLength, dy: 0),
            withCenter: topRightPoint,
            addLinePoint: topRightPoint.offsetBy(dx: 0, dy: Constant.cornerLength)
        )

        let bottomRightCorner = createCorner(
            movePoint: bottomRightPoint.offsetBy(dx: 0, dy: -Constant.cornerLength),
            withCenter: bottomRightPoint,
            addLinePoint: bottomRightPoint.offsetBy(dx: -Constant.cornerLength, dy: 0)
        )

        let bottomLeftCorner = createCorner(
            movePoint: bottomLeftPoint.offsetBy(dx: Constant.cornerLength, dy: 0),
            withCenter: bottomLeftPoint,
            addLinePoint: bottomLeftPoint.offsetBy(dx: 0, dy: -Constant.cornerLength)
        )

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
        path.addRect(bounds)
        path.addRect(rectOfInterest)

        layer.path = path
        layer.fillColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6).cgColor
        layer.fillRule = .evenOdd

        return layer
    }

    private func createCorner(movePoint: CGPoint, withCenter: CGPoint, addLinePoint: CGPoint) -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: movePoint)
        path.addArc(
            withCenter: withCenter,
            radius: 0,
            startAngle: 0,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: addLinePoint)

        return path
    }
}

extension QRReaderView: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
                  let stringValue = readableObject.stringValue else {
                self.delegate?.qrCodeDidComplete(.fail)
                return
            }
            
            self.delegate?.qrCodeDidComplete(.success(stringValue))
            self.session?.stopRunning()
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

    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        var point = self
        point.x += dx
        point.y += dy
        return point
    }
}
