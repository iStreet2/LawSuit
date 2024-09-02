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
    @Published var selectedClient: Client? = nil
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createClient(
        name: String,
        occupation: String,
        rg: String,
        cpf: String,
        affiliation: String,
        maritalStatus: String,
        nationality: String,
        birthDate: Date,
        cep: String,
        address: String,
        addressNumber: String,
        neighborhood: String,
        complement: String,
        state: String,
        city: String,
        email: String,
        telephone: String,
        cellphone: String
    ) {
        let client = Client(context: context)
        
        // Criação da pasta raiz
        let folder = Folder(context: context)
        folder.name = "\(name)"
        folder.id = "root\(name)"
        
        client.rootFolder = folder
        folder.parentClient = client
        
        // Atributos
        client.name = name
        client.id = UUID().uuidString
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
        
        saveContext()
    }

    
    func testClient() {
        let client = Client(context: context)
        client.name = "Bonito"
        client.id = UUID().uuidString
        client.age = Int64(20)
        
        let rootFolder = Folder(context: context)
        rootFolder.name = "\(client.name)"
        rootFolder.id = "root\(client.name)"
        rootFolder.parentClient = client
        
        client.rootFolder = rootFolder
        
        saveContext()
//		 return client
    }
    
    func deleteClient(client: Client/*, lawyer: Lawyer*/) {
        context.delete(client)
        saveContext()
//        lawyer.removeFromClients(client)
    }
    
    func editClient(
        client: Client,
        name: String,
        occupation: String,
        rg: String,
        cpf: String,
        affiliation: String,
        maritalStatus: String,
        nationality: String,
        birthDate: Date,
        cep: String,
        address: String,
        addressNumber: String,
        neighborhood: String,
        complement: String,
        state: String,
        city: String,
        email: String,
        telephone: String,
        cellphone: String
    ) {
        // Atualiza os atributos do cliente
        client.name = name
        client.occupation = occupation
        client.rg = rg
        client.cpf = cpf
        client.affiliation = affiliation
        client.maritalStatus = maritalStatus
        client.nationality = nationality
        client.birthDate = birthDate
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
        
        // Salva o contexto para persistir as mudanças
        saveContext()
    }


    
    func addPhotoOnClient(client: Client, photo: Data) {
        client.photo = photo
        saveContext()
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
