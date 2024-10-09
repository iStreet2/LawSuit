//
//  ClientManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation
import CoreData


class ClientManager {

    func deleteClient(client: Client) {
        
    }
    
    func editClient(client: Client, name: String, socialName: String?, occupation: String, rg: String, cpf: String, affiliation: String, maritalStatus: String, nationality: String, birthDate: Date, cep: String, address: String, addressNumber: String, neighborhood: String, complement: String, state: String, city: String, email: String, telephone: String, cellphone: String) {
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
    }
    
    func addPhotoOnClient(client: Client, photo: Data) {
        client.photo = photo
    }
    
    private func calculateAge(from birthDate: Date) -> Int {
        let calendar = Calendar.current
        let currentDate = Date()
        
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        return ageComponents.year ?? 0
    }
    
    func authorIsClient(lawsuit: Lawsuit) -> Bool {
        if lawsuit.authorID.hasPrefix("client:") {
            return true
        } else {
            return false
        }
    }
    
    func fetchAllClients() -> [Client] {
        let fetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
        do {
            let clients = try context.fetch(fetchRequest)
            return clients
        } catch {
            print("Erro ao buscar clientes: \(error)")
            return []
        }
    }
}
