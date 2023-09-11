//
//  CoreDataPersistenceService.swift
//  LottoDairy
//
//  Created by Brody on 2023/07/27.
//

import CoreData

final class CoreDataPersistenceService: CoreDataPersistenceServiceProtocol {
    
    static let coreDataModelName = "LottoDiaryModel"
    static let shared = CoreDataPersistenceService()
    
    lazy var context: NSManagedObjectContext? = {
        guard self.isPersistentStoreLoaded else { return nil }
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext? = {
        guard self.isPersistentStoreLoaded else { return nil }
        let context = self.persistentContainer.newBackgroundContext()
        context.automaticallyMergesChangesFromParent = true
        return context
    }()
    
    private var isPersistentStoreLoaded = false
    private var persistentContainer: NSPersistentContainer
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: Self.coreDataModelName)
        self.persistentContainer.loadPersistentStores { [weak self] _, error in
            guard error == nil else { return }
            self?.isPersistentStoreLoaded = true
        }
    }
}
