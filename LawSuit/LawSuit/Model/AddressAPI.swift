//
//  AddressAPI.swift
//  LawSuit
//
//  Created by Emily Morimoto on 09/09/24.
//

import Foundation

struct AddressAPI: Codable, Identifiable{
    var id: UUID?
    var cep: String
    var logradouro: String
    var bairro: String
    var estado: String
    var localidade: String
    
    init() {
        self.id = UUID()
        self.cep = ""
        self.logradouro = "" 
        self.bairro = ""
        self.estado = ""
        self.localidade = ""
    }
}
