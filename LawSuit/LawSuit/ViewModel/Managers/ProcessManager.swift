//
//  ProcessManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation
import CoreData

class ProcessManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createProcess(name: String, number: String, category: String, lawyer: Lawyer, defendant: String, autor: Client, actionDate: Date) {
        let lawsuit = Lawsuit(context: context)
        lawsuit.name = name
        lawsuit.category = category
        lawsuit.number = number
        lawyer.addToLawsuit(lawsuit)
        lawsuit.defendant = defendant
        lawsuit.autor = autor
        lawsuit.actionDate = actionDate
        lawsuit.id = UUID().uuidString
        saveContext()
    }
    
    func deleteProcess(lawsuit: Lawsuit) {
        context.delete(lawsuit)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on lawsuit")
        }
    }
    
}
