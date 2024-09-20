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
    
    func addUpdates(lawsuit: Lawsuit, updates: [Update]) {
        for update in updates {
            lawsuit.addToUpdates(update)
        }
        saveContext()
    }
    
    func appendUpdate(lawsuit: Lawsuit, update: Update) {
        lawsuit.addToUpdates(update)
        saveContext()
    }
    
    func createLawsuit(name: String, number: String, court: String, category: String, lawyer: Lawyer, defendant: String, author: Client, actionDate: Date) -> Lawsuit {
        let lawsuit = Lawsuit(context: context)
        lawsuit.name = name
        lawsuit.category = category
        lawsuit.number = number
        lawsuit.court = court
        lawyer.addToLawsuits(lawsuit)
        lawsuit.defendant = defendant
        lawsuit.parentAuthor = author
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
    
    func createLawsuitNonDistribuited(name: String, number: String, category: String, lawyer: Lawyer, defendant: String, author: Client, actionDate: Date) {
        let lawsuit = Lawsuit(context: context)
        lawsuit.name = name
        lawsuit.category = category
        lawyer.addToLawsuits(lawsuit)
        lawsuit.defendant = defendant
        lawsuit.parentAuthor = author
        lawsuit.id = UUID().uuidString
        
        // Criar pasta raiz para esse processo:
        let rootFolder = Folder(context: context)
        rootFolder.parentLawsuit = lawsuit
        rootFolder.name = lawsuit.name
        rootFolder.id = UUID().uuidString
        
        lawsuit.rootFolder = rootFolder
        
        saveContext()
    }
    
    func editLawSuit(lawsuit: Lawsuit, number: String, category: String, defendant: String, author: Client, actionDate: Date) {
        lawsuit.number = number
        lawsuit.category = category
        lawsuit.defendant = defendant
        lawsuit.parentAuthor = author
        lawsuit.actionDate = actionDate
        saveContext()
    }
    
    func deleteLawsuit(lawsuit: Lawsuit) {
        context.delete(lawsuit)
        saveContext()
    }
    
    //@MainActor
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on lawsuit \(error)")
        }
    }
    
}
