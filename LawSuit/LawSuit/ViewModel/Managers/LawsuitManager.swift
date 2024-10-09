//
//  ProcessManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation
import CoreData

class LawsuitManager {
    
    func addUpdates(lawsuit: Lawsuit, updates: [Update]) {
        for update in updates {
            lawsuit.updates.append(update)
        }
    }
    
    func appendUpdate(lawsuit: Lawsuit, update: Update) {
        lawsuit.updates.append(update)
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
    
    func fetchAllLawsuits() -> [Lawsuit] {
        let fetchRequest: NSFetchRequest<Lawsuit> = Lawsuit.fetchRequest()
        do {
            let lawsuits = try context.fetch(fetchRequest)
            return lawsuits
        } catch {
            print("Erro ao buscar processos: \(error)")
            return []
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
    
}
