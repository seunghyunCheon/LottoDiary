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

    @NSManaged public var date: Date
    @NSManaged public var goalAmount: Int
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalAmountEntity> {
        return NSFetchRequest<GoalAmountEntity>(entityName: "GoalAmountEntity")
    }
    
    func update(_ goalAmount: Int) {
        self.goalAmount = goalAmount
        self.date = Date()
    }
}

extension GoalAmountEntity : Identifiable { }
