//
//  GoalAmountEntity+CoreDataProperties.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/27.
//
//

import Foundation
import CoreData


extension GoalAmountEntity {

    @NSManaged public var goalAmount: Int16
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalAmountEntity> {
        return NSFetchRequest<GoalAmountEntity>(entityName: "GoalAmountEntity")
    }
    
    func update(_ goalAmount: Int16) {
        self.goalAmount = goalAmount
    }
}

extension GoalAmountEntity : Identifiable { }
