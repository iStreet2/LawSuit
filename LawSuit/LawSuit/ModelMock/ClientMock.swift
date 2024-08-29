//
//  Client.swift
//  LawSuit
//
//  Created by Giovanna Micher on 26/08/24.
//

import Foundation

struct ClientMock {
    var name: String
    var occupation: String
    var rg: String
    var cpf: String
    var affiliation: String
    var maritalStatus: String
    var nationality: String
    var birthDate: Date
    
    var cep: String
    var address: String
    var addressNumber: String
    var neighborhood: String
    var complement: String
    var state: String
    var city: String
    
    var email: String
    var telephone: String
    var cellphone: String
    //var other: [String:String]
    
    init() {
        self.name = ""
        self.occupation = ""
        self.rg = ""
        self.cpf = ""
        self.affiliation = ""
        self.maritalStatus = ""
        self.nationality = ""
        self.birthDate = Date()
        self.cep = ""
        self.address = ""
        self.addressNumber = ""
        self.neighborhood = ""
        self.complement = ""
        self.state = ""
        self.city = ""
        self.email = ""
        self.telephone = ""
        self.cellphone = ""
    }
    
    init(name: String, occupation: String, rg: String, cpf: String, affiliation: String, maritalStatus: String, nationality: String, birthDate: Date, cep: String, address: String, addressNumber: String, neighborhood: String, complement: String, state: String, city: String, email: String, telephone: String, cellphone: String) {
        self.name = name
        self.occupation = occupation
        self.rg = rg
        self.cpf = cpf
        self.affiliation = affiliation
        self.maritalStatus = maritalStatus
        self.nationality = nationality
        self.birthDate = birthDate
        self.cep = cep
        self.address = address
        self.addressNumber = addressNumber
        self.neighborhood = neighborhood
        self.complement = complement
        self.state = state
        self.city = city
        self.email = email
        self.telephone = telephone
        self.cellphone = cellphone
    }
    
}
