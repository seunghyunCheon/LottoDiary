//
//  LottoQRFlowProtocol.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/24.
//

import UIKit

protocol LottoQRFlowProtocol: Presentable {
    var onCameraNotAvailableAlert: ((UIAlertController) -> ())? { get set }
    var onInvalidAlert: ((UIAlertController) -> ())? { get set }
}
