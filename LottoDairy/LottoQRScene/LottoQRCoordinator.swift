//
//  LottoQRCoordinator.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/24.
//

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
        router.setRootModule(lottoQRFlow)
    }

}
