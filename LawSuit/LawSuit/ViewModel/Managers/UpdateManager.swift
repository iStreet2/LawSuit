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
    
    func createUpdate(name: String, date: Date, lawsuit: Lawsuit) -> Update {
        let update = Update(context: context)
        update.name = name
        update.date = date
        update.parentLawsuit = lawsuit
        return update
    }
    
    func getLatestUpdateDate(lawsuit: Lawsuit) -> Date? {
        let updatesArray = (lawsuit.updates as? Set<Update>)?.sorted {
            ($0.date ?? Date.distantPast) > ($1.date ?? Date.distantPast)
        }
        return updatesArray?.first?.date
    }
    
}
