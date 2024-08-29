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
    
    func createClient(
        name: String,
        occupation: String?,
        rg: String?,
        cpf: String?,
        /*lawyer: Lawyer,*/
        affiliation: String?,
        maritalStatus: String?,
        nationality: String?,
        birthDate: Date?,
        cep: String?,
        address: String?,
        addressNumber: String?,
        neighborhood: String?,
        complement: String?,
        state: String?,
        city: String?,
        email: String?,
        telephone: String?,
        cellphone: String?
    ) {
        let client = Client(context: context)
        // Relacionamentos
        //client.parentLawyer = lawyer
        
        // Criação da pasta raiz
        let folder = Folder(context: context)
        folder.name = "\(client.name ?? "Sem nome")"
        folder.id = "root\(client.name ?? "Sem nome")"
        
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
        if let birthDate = birthDate {
            client.age = Int64(calculateAge(from: birthDate))
        }
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
        rootFolder.name = "\(client.name ?? "Sem Nome")"
        rootFolder.id = "root\(client.name ?? "Sem nome")"
        rootFolder.parentClient = client
        
        client.rootFolder = rootFolder
        
        saveContext()
//		 return client
    }
    
    func deleteClient(client: Client, lawyer: Lawyer) {
        context.delete(client)
        lawyer.removeFromClients(client)
    }
    
    func editClient(client: Client, name: String, age: Int64, photo: Data) {
        client.name = name
        client.age = age
        client.photo = photo
        saveContext()
    }
    
    func addPhotoOnClient(client: Client, photo: Data) {
        client.photo = photo
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on client (\(error)")
        }
    }
    
    private func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        return ageComponents.year ?? 0
    }
}
