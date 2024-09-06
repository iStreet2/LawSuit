//
//  EntityManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 05/09/24.
//

import Foundation
import CoreData

class EntityManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createEntity(name: String) {
        var entity = Entity(context: context)
        entity.id = UUID().uuidString
        entity.name = name
        saveContext()
    }
    
    func createAndReturnEntity(name: String) -> Entity {
        var entity = Entity(context: context)
        entity.id = UUID().uuidString
        entity.name = name
        saveContext()
        return entity
    }
    
    func deleteEntity(entity: Entity) {
        context.delete(entity)
    }
    
    func editEntity(entity: Entity, name: String) {
        entity.name = name
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving entity: \(error)")
        }
    }
}
