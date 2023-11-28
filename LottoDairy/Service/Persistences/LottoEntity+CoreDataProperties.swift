//
//  LottoEntity+CoreDataProperties.swift
//  LottoDairy
//
//  Created by Brody on 2023/09/16.
//
//

import Foundation
import CoreData


extension LottoEntity {

    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var type: String
    @NSManaged public var purchaseAmount: Int
    @NSManaged public var winningAmount: Int
    @NSManaged public var lottoNumbers: [[Int]]
    @NSManaged public var roundNumber: Int
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LottoEntity> {
        return NSFetchRequest<LottoEntity>(entityName: "LottoEntity")
    }
    
    func update(lotto: Lotto) {
        self.id = lotto.id
        self.date = lotto.date
        self.type = lotto.type.rawValue
        self.purchaseAmount = lotto.purchaseAmount
        self.winningAmount = lotto.winningAmount
        self.lottoNumbers = lotto.lottoNumbers
    }
}

extension LottoEntity : Identifiable {
    func convertToDomain() -> Lotto {
        return Lotto(
            id: self.id,
            date: self.date,
            type: LottoType(rawValue: self.type) ?? .lotto,
            purchaseAmount: self.purchaseAmount,
            winningAmount: self.winningAmount,
            lottoNumbers: self.lottoNumbers
        )
    }
}
