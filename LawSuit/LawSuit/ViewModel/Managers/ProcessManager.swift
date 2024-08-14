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
        let process = Process(context: context)
        process.name = name
        process.category = category
        process.number = number
        process.lawyer = lawyer
        process.defendant = defendant
        process.autor = autor
        process.actionDate = actionDate
        process.id = UUID().uuidString
        saveContext()
    }
    
    func deleteProcess(process: Process) {
        context.delete(process)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on process")
        }
    }
    
}
