//
//  DefaultLottoQRUseCase.swift
//  LottoDairy
//
//  Created by Sunny on 10/19/23.
//

import Combine

enum ErrorMan: Error {
    case ee
}

final class DefaultLottoQRUseCase: LottoQRUseCase {

    func validateLottoURL(_ url: String) -> Bool {
        return url.contains(LottoAPI.baseURL)
    }
    
    func crawlLottoResult(_ url: String) -> AnyPublisher<Lotto, Error> {
        // 1. url을 통해 크롤링한다.
        // 2. 정보를 기반으로 로또를 생성하고 반환한다.
        // 3. 외부에서 당첨금액이 없다면 달력으로 화면을 이동하고, 당첨금액이 있다면 당첨화면을 보여준다.
        
        return Fail(error: ErrorMan.ee).eraseToAnyPublisher()
    }
}
