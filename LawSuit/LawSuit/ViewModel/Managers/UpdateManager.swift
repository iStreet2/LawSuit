//
//  UpdateManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation
import CoreData

class UpdateManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createUpdate(name: String, date: Date, desc: String?, process: Process) {
        let update = Update(context: context)
        update.name = name
        update.date = date
        update.desc = desc
        update.process = process
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on update")
        }
    }
    
}
