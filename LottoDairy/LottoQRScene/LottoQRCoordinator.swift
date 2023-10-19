//
//  LottoQRCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/24.
//

import UIKit

final class LottoQRCoordinator: BaseCoordinator {

    private let router: Router
    private let moduleFactory: LottoQRModuleFactory
    private let coordinatorFactory: CoordinatorFactory

    init(router: Router, moduleFactory: LottoQRModuleFactory, coordinatorFactory: CoordinatorFactory) {
        self.router = router
        self.moduleFactory = moduleFactory
        self.coordinatorFactory = coordinatorFactory
    }

    override func start() {
        var lottoQRFlow = moduleFactory.makeLottoQRFlow()

        lottoQRFlow.onCameraNotAvailableAlert = runCameraNotAvailableAlert()
        lottoQRFlow.onInvalidAlert = runInvalidAlert()

        router.setRootModule(lottoQRFlow)
    }

    private func runCameraNotAvailableAlert() -> ((UIAlertController) -> ()) {
        return { [weak self] alertController in
            self?.router.present(alertController, animated: true)
            // 해당 카메라 vc를 dismiss 해야 할까 아니면 검은 vc를 그대로 둬야 할까
//            self?.router.dismissModule(animated: true, completion: nil)
        }
    }
    
    private func runInvalidAlert() -> ((UIAlertController) -> ()) {
        return { [weak self] alertController in
            self?.router.present(alertController, animated: true)
        }
    }
}
