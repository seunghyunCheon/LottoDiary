//
//  LottoValidationModuleFactory.swift
//  LottoDairy
//
//  Created by Sunny on 11/3/23.
//

protocol AppSetupModuleFactory {
    func makeLottoValidationFlow() -> LottoValidationFlowProtocol
    func makeUserSetupFlow() -> UserSetupFlowProtocol
}
