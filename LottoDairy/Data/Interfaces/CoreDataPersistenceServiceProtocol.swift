//
//  CoreDataPersistenceServiceProtocol.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/27.
//

import CoreData

protocol CoreDataPersistenceServiceProtocol {
    var context: NSManagedObjectContext? { get }
    var backgroundContext: NSManagedObjectContext? { get }
}
