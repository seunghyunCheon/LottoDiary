//
//  ModuleFactoryImp.swift
//  LottoDairy
//
//  Created by Sunny on 2023/07/05.
//

final class ModuleFactoryImp: HomeModuleFactory, OnboardingModuleFactory, LottoQRModuleFactory {
    
    func makeHomeFlow() -> HomeFlowProtocol {
        return HomeViewController()
    }
    
    func makeOnboardingFlow() -> OnboardingFlowProtocol {
        return OnboardingViewController()
    }

    func makeLottoQRFlow() -> LottoQRFlowProtocol {
        return LottoQRViewController()
    }
}
