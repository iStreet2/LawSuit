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
    
    func createClient(name: String, socialName: String?, occupation: String, rg: String, cpf: String, lawyer: Lawyer, affiliation: String, maritalStatus: String, nationality: String, birthDate: Date, cep: String, address: String, addressNumber: String, neighborhood: String, complement: String, state: String, city: String, email: String, telephone: String, cellphone: String, photo: Data? = nil) -> Client {
        let client = Client(context: context)
        let folder = Folder(context: context)
        folder.name = "\(name)"
        folder.id = "root\(name)"
        client.rootFolder = folder
        folder.parentClient = client
        client.name = name
        client.socialName = socialName
        client.id = "client:\(UUID().uuidString)"
        client.occupation = occupation
        client.rg = rg
        client.cpf = cpf
        client.affiliation = affiliation
        client.maritalStatus = maritalStatus
        client.nationality = nationality
        client.birthDate = birthDate
        client.age = Int64(calculateAge(from: birthDate))
        client.cep = cep
        client.address = address
        client.addressNumber = addressNumber
        client.neighborhood = neighborhood
        client.complement = complement
        client.state = state
        client.city = city
        client.email = email
        client.telephone = telephone
        client.cellphone = cellphone
        client.photo = photo
        saveContext()
		 return client
    }
    
    func deleteClient(client: Client/*, lawyer: Lawyer*/) {
        context.delete(client)
        saveContext()
//        lawyer.removeFromClients(client)
    }
    
    func editClient(client: Client, name: String, socialName: String?, occupation: String, rg: String, cpf: String, affiliation: String, maritalStatus: String, nationality: String, birthDate: Date, cep: String, address: String, addressNumber: String, neighborhood: String, complement: String, state: String, city: String, email: String, telephone: String, cellphone: String, photo: Data?) {
        client.name = name
        client.socialName = socialName
        client.occupation = occupation
        client.rg = rg
        client.cpf = cpf
        client.affiliation = affiliation
        client.maritalStatus = maritalStatus
        client.nationality = nationality
        client.birthDate = birthDate
        client.age = Int64(calculateAge(from: birthDate))
        client.cep = cep
        client.address = address
        client.addressNumber = addressNumber
        client.neighborhood = neighborhood
        client.complement = complement
        client.state = state
        client.city = city
        client.email = email
        client.telephone = telephone
        client.cellphone = cellphone
        client.photo = photo
        saveContext()
    }
    
    func addPhotoOnClient(client: Client, photo: Data) {
        client.photo = photo
        saveContext()
    }
    
    func fetchFromName(name: String) -> Client? {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name ==[c] %@ OR socialName ==[c] %@", name, name)
        do {
            let fetchedClients = try context.fetch(fetchRequest)
            if let client = fetchedClients.first {
                return client
            }
        } catch {
            print("Error fetching clients: \(error.localizedDescription)")
            return nil
        }
        return nil
    }
    
    func fetchFromId(id: String) -> Client? {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        do {
            let fetchedClients = try context.fetch(fetchRequest)
            if let client = fetchedClients.first {
                return client
            }
        } catch {
            print("Error fetching clients: \(error.localizedDescription)")
            return nil
        }
        return nil
    }
    
    func copyClientProperties(from sourceClient: Client, to targetClient: Client) {
        // Primeiro, copiamos as propriedades simples usando Key-Value Coding (KVC)
        let attributes = sourceClient.entity.attributesByName
        for (attributeName, _) in attributes {
            if let value = sourceClient.value(forKey: attributeName) {
                targetClient.setValue(value, forKey: attributeName)
            }
        }
        
        // Em seguida, lidamos com as relações (to-one e to-many)
        let relationships = sourceClient.entity.relationshipsByName
        for (relationshipName, relationshipDescription) in relationships {
            if relationshipDescription.isToMany {
                // Relações to-many (NSSet)
                if let value = sourceClient.value(forKey: relationshipName) as? NSSet {
                    targetClient.setValue(value, forKey: relationshipName)
                }
            } else {
                // Relações to-one (NSManagedObject)
                if let value = sourceClient.value(forKey: relationshipName) as? NSManagedObject {
                    targetClient.setValue(value, forKey: relationshipName)
                }
            }
        }
    }
    
    private func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        return ageComponents.year ?? 0
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on client (\(error)")
        }
    }
    
    
}
