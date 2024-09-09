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
        let entity = Entity(context: context)
        entity.id = UUID().uuidString
        entity.name = name
        saveContext()
    }
    
    func createAndReturnEntity(name: String) -> Entity {
        let entity = Entity(context: context)
        entity.id = UUID().uuidString
        entity.name = name
        saveContext()
        return entity
    }
    
    func fetchFromName(name: String) -> Entity? {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let fetchedClients = try context.fetch(fetchRequest)
            if let client = fetchedClients.first {
                return client
            }
        } catch {
            print("Error fetching entitys: \(error.localizedDescription)")
            return nil
        }
        return nil
    }
    
    func fetchFromID(id: String) -> Entity? {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let fetchedClients = try context.fetch(fetchRequest)
            if let client = fetchedClients.first {
                return client
            }
        } catch {
            print("Error fetching entitys: \(error.localizedDescription)")
            return nil
        }
        return nil
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
