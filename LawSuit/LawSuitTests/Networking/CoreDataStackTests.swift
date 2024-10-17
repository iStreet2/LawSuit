//
//  CoreDataStackTests.swift
//  LawSuitTests
//
//  Created by Giovanna Micher on 20/09/24.
//

import Foundation
import CoreData

struct CoreDataStackTests {
    let persistentContainer: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        persistentContainer = NSPersistentContainer(name: "Model" )
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("Failed to load in-memory Core Data stack: \(error)")
            }
        }
        
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.automaticallyMergesChangesFromParent = true
        context.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
    }
}
