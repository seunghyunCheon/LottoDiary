//
//  AddLottoViewModel.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/15.
//

final class AddLottoViewModel {
    
    private let addLottoUseCase: AddLottoUseCase
    private let addLottoValidationUseCase: AddLottoValidationUseCase
    
    init(addLottoUseCase: AddLottoUseCase, addLottoValidationUseCase: AddLottoValidationUseCase) {
        self.addLottoUseCase = addLottoUseCase
        self.addLottoValidationUseCase = addLottoValidationUseCase
    }
}
