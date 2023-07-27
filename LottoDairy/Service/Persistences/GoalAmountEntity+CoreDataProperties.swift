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

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalAmountEntity> {
        return NSFetchRequest<GoalAmountEntity>(entityName: "GoalAmountEntity")
    }

    @NSManaged public var goalAmount: Int16
}

extension GoalAmountEntity : Identifiable { }
