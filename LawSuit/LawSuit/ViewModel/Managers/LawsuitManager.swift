//
//  ProcessManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation
import CoreData

class LawsuitManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createAndReturnLawsuit(name: String, number: String, court: String, category: String, lawyer: Lawyer, defendantID: String, authorID: String, actionDate: Date) -> Lawsuit {
        let lawsuit = Lawsuit(context: context)
        lawsuit.name = name
        lawsuit.category = category
        lawsuit.number = number
        lawsuit.court = court
        lawyer.addToLawsuits(lawsuit)
        lawsuit.defendantID = defendantID
        lawsuit.authorID = authorID
        lawsuit.actionDate = actionDate
        lawsuit.id = UUID().uuidString
        
        // Criar pasta raiz para esse processo:
        let rootFolder = Folder(context: context)
        rootFolder.parentLawsuit = lawsuit
        rootFolder.name = lawsuit.name
        rootFolder.id = UUID().uuidString
        
        lawsuit.rootFolder = rootFolder
        saveContext()
        return lawsuit
    }
    
    func createAndReturnLawsuitNonDistribuited(name: String, number: String, category: String, lawyer: Lawyer, defendantID: String, authorID: String, actionDate: Date) -> Lawsuit{
        let lawsuit = Lawsuit(context: context)
        lawsuit.name = name
        lawsuit.category = category
        lawyer.addToLawsuits(lawsuit)
        lawsuit.defendantID = defendantID
        lawsuit.authorID = authorID
        lawsuit.id = UUID().uuidString
        
        // Criar pasta raiz para esse processo:
        let rootFolder = Folder(context: context)
        rootFolder.parentLawsuit = lawsuit
        rootFolder.name = lawsuit.name
        rootFolder.id = UUID().uuidString
        
        lawsuit.rootFolder = rootFolder
        
        saveContext()
        return lawsuit
    }
    
    func editLawSuit(lawsuit: Lawsuit, name: String, number: String, court: String, category: String, defendantID: String, authorID: String, actionDate: Date) {
        lawsuit.name = name
        lawsuit.number = number
        lawsuit.court = court
        lawsuit.category = category
        lawsuit.defendantID = defendantID
        lawsuit.authorID = authorID
        lawsuit.actionDate = actionDate
        saveContext()
    }
    
    func deleteLawsuit(lawsuit: Lawsuit) {
        context.delete(lawsuit)
        saveContext()
    }
    
    func fetchFromClient(client: Client) -> [Lawsuit]? {
        let fetchRequest: NSFetchRequest<Lawsuit> = Lawsuit.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "authorID == %@ OR defendantID == %@", client.id, client.id)
        
        do {
            let lawsuits = try context.fetch(fetchRequest)
            return lawsuits
        } catch {
            print("Error fetching lawsuits related to Client: \(client) \(error)")
        }
        
        return nil
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on lawsuit \(error)")
        }
    }
    
}
