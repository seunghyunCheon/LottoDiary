//
//  LottoQRViewController.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/24.
//

import UIKit

final class LottoQRViewController: UIViewController, LottoQRFlowProtocol {

    private lazy var qrReaderView: UIView = {
        let qrReaderView = QRReaderView(frame: view.bounds)
        qrReaderView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return qrReaderView
    }()

    init() {
        print("로또 컨트롤러 생성 완료")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(qrReaderView)
    }
}
