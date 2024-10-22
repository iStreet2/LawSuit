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
    
    func createLawsuit(authorName: String, defendantName: String, number: String, court: String, category: String, lawyer: Lawyer, defendantID: String, authorID: String, actionDate: Date, isDistributed: Bool) -> Lawsuit {
        
        let lawsuit = Lawsuit(context: context)
        lawsuit.authorName = authorName
        lawsuit.defendantName = defendantName
        lawsuit.name = "\(authorName) X \(defendantName)"
        lawsuit.category = category
        lawsuit.number = number
        lawsuit.court = court
        lawyer.addToLawsuits(lawsuit)
        lawsuit.defendantID = defendantID
        lawsuit.authorID = authorID
        lawsuit.actionDate = actionDate
        lawsuit.id = UUID().uuidString
        lawsuit.isDistributed = isDistributed
        
        // Criar pasta raiz para esse processo:
        let rootFolder = Folder(context: context)
        rootFolder.parentLawsuit = lawsuit
        rootFolder.name = "lawsuit"
        rootFolder.id = "root\(number)"
        
        lawsuit.rootFolder = rootFolder
        saveContext()
        
        return lawsuit
    }
    
    func createLawsuitNonDistribuited(authorName: String, defendantName: String, number: String, category: String, lawyer: Lawyer, defendantID: String, authorID: String, actionDate: Date, isDistributed: Bool) -> Lawsuit{
        
        let lawsuit = Lawsuit(context: context)
        lawsuit.authorName = authorName
        lawsuit.defendantName = defendantName
        lawsuit.name = "\(authorName) X \(defendantName)"
        lawsuit.category = category
        lawyer.addToLawsuits(lawsuit)
        lawsuit.defendantID = defendantID
        lawsuit.authorID = authorID
        lawsuit.id = UUID().uuidString
        lawsuit.isDistributed = isDistributed
        
        // Criar pasta raiz para esse processo:
        let rootFolder = Folder(context: context)
        rootFolder.parentLawsuit = lawsuit
        rootFolder.name = "root(\(number)"
        rootFolder.id = UUID().uuidString
        
        lawsuit.rootFolder = rootFolder
        
        saveContext()
        
        return lawsuit
    }
    
    func editLawSuit(lawsuit: Lawsuit, authorName: String, defendantName: String, number: String, court: String, category: String, defendantID: String, authorID: String, actionDate: Date, isDistributed: Bool) {
        lawsuit.authorName = authorName
        lawsuit.defendantName = defendantName
        lawsuit.number = number
        lawsuit.court = court
        lawsuit.category = category
        lawsuit.defendantID = defendantID
        lawsuit.authorID = authorID
        lawsuit.actionDate = actionDate
        lawsuit.isDistributed = isDistributed
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
    
    func doesLawsuitExist(lawsuitNumber: String) -> Bool {
        let fetchRequest: NSFetchRequest<Lawsuit> = Lawsuit.fetchRequest()
        let lawsuitNumberFormatted = NetworkingManager.shared.removeCharactersFromLawsuitNumber(lawsuitNumber: lawsuitNumber)
        fetchRequest.predicate = NSPredicate(format: "number == %@", lawsuitNumberFormatted)
        
        do {
            let existingLawsuits = try context.fetch(fetchRequest)
            print(lawsuitNumber)
            print("numero de lawsuits com esse nro existentes: \(existingLawsuits.count)")
            return !existingLawsuits.isEmpty //true se tiver processos com o mesmo número
        } catch {
            print("Erro ao buscar processos: \(error)")
            return false //em caso de erro, é pq o processo não existe
        }
        
    }
    
    func fetchDefendantName(for client: Client) -> String {
        
        if let lawsuits = fetchFromClient(client: client) {
            for lawsuit in lawsuits {
                let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id == %@", lawsuit.defendantID)
                
                do {
                    let defendants = try context.fetch(fetchRequest)
                    
                    lawsuit.name = client.socialName != nil ? "\(String(describing: client.socialName)) X \(defendants.first?.name ?? "")" : "\(client.name) X \(defendants.first?.name ?? "")"
                    print(lawsuit.name)
                    return lawsuit.name
                } catch {
                    print("Erro ao buscar o réu: \(error)")
                    return ""
                }
            }
            saveContext()
        }
        return ""
    }
    
}
