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
        client.parentLawyer = lawyer
        client.id = UUID().uuidString
        
        let folder = Folder(context: context)
        folder.name = "\(client.name ?? "Sem nome")"
        folder.id = "root\(client.name ?? "Sem nome")"
        
        client.rootFolder = folder
        folder.parentClient = client
        
        saveContext()
        
    }
    
    func testClient() {
        let client = Client(context: context)
        client.name = "Bonito"
        client.id = UUID().uuidString
        client.age = Int64(20)
        
        let rootFolder = Folder(context: context)
        rootFolder.name = "\(client.name ?? "Sem Nome")"
        rootFolder.id = "root\(client.name ?? "Sem nome")"
        rootFolder.parentClient = client
        
        client.rootFolder = rootFolder
        
        saveContext()
//		 return client
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
            print("Error while saving context on client (\(error)")
        }
    }
}
