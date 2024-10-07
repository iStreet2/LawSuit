//
//  LawyerManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation
import CoreData

class LawyerManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
//        initLawyer()
    }
    
    func initLawyer() {
        let amountCoreDataItems = try? context.count(for: Lawyer.fetchRequest())
        guard amountCoreDataItems == 0 else{
            return
        }
        let lawyer = Lawyer(context: context)
        lawyer.name = "Você"
        saveContext()
    }
    
    func createLawyer(name: String, photo: Data, oab: String) {
        let lawyer = Lawyer(context: context)
        lawyer.name = name
        lawyer.photo = photo
        lawyer.id = UUID().uuidString
        saveContext()
    }
    
    func deleteLawyer(lawyer: Lawyer) {
        context.delete(lawyer)
        saveContext()
    }
    
    func editLawyer(lawyer: Lawyer, name: String, photo: Data) {
        lawyer.name = name
        lawyer.photo = photo
        saveContext()
    }
    
    func fetchAllLawyers() -> [Lawyer] {
        let fetchRequest: NSFetchRequest<Lawyer> = Lawyer.fetchRequest()
        do {
            let lawyers = try context.fetch(fetchRequest)
            return lawyers
        } catch {
            print("Erro ao buscar entidades: \(error)")
            return []
        }
    }
    
    func saveContext() {
//        do {
//            try context.save()
//        } catch {
//            print("Error while saving context on lawyer")
//        }
    }
    
}
