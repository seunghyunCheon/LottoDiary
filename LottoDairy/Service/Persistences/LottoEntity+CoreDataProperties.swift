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

    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var purchaseAmount: Int
    @NSManaged public var winningAmount: Int
    @NSManaged public var lottoNumbers: [[Int]]
    @NSManaged public var isResultAnnounced: Bool
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<LottoEntity> {
        return NSFetchRequest<LottoEntity>(entityName: "LottoEntity")
    }
    
    func update(lotto: Lotto) {
        self.id = lotto.id
        self.type = lotto.type.rawValue
        self.purchaseAmount = lotto.purchaseAmount
        self.winningAmount = lotto.winningAmount
        self.isResultAnnounced = lotto.isResultAnnounced
        self.lottoNumbers = lotto.lottoNumbers
    }

}

extension LottoEntity : Identifiable { }
