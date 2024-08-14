//
//  ClientManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation
import CoreData


class ClientManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createClient(name: String, age: Int64, photo: Data, lawyer: Lawyer) {
        let client = Client(context: context)
        client.name = name
        client.age = age
        client.photo = photo
        client.lawyer = lawyer
        client.id = UUID().uuidString
        saveContext()
        
    }
    
    func deleteClient(client: Client, lawyer: Lawyer) {
        context.delete(client)
        lawyer.removeFromClients(client)
    }
    
    func editClient(client: Client, name: String, age: Int64, photo: Data) {
        client.name = name
        client.age = age
        client.photo = photo
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on client")
        }
    }
}
