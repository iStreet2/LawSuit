//
//  EntityManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 05/09/24.
//

import Foundation
import CoreData

class EntityManager {
    
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
    
    func authorIsEntity(lawsuit: Lawsuit) -> Bool {
        if lawsuit.authorID.hasPrefix("client:") {
            return false
        } else {
            return true
        }
    }
    
    func deleteEntity(entity: Entity) {
        
    }
    
    func editEntity(entity: Entity, name: String) {
        entity.name = name
    }
    
    func fetchAllEntities() -> [Entity] {
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
        do {
            let entities = try context.fetch(fetchRequest)
            return entities
        } catch {
            print("Error fetching entitys: \(error.localizedDescription)")
            return []
        }
    }
}
