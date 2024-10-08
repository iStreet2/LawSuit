//
//  Client.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 07/10/24.
//

import Foundation
import CloudKit

class Client {
	var address: String
	var addressNumber: String
	var affiliation: String
	var age: Int64
	var birthDate: Date
	var cellphone: String
	var cep: String
	var city: String
	var complement: String
	var cpf: String
	var createdAt: Date
	var email: String
	var id: String
	var maritalStatus: String
	var name: String
	var nationality: String
	var neighborhood: String
	var occupation: String
	var rg: String
	var rootFolder: Folder
	var state: String
	var telephone: String
	
	var recordName: String? // MARK: IMPORTANTE
	
	init(address: String, addressNumber: String, affiliation: String, age: Int64, birthDate: Date, cellphone: String, cep: String, city: String, complement: String, cpf: String, createdAt: Date, email: String, id: String, maritalStatus: String, name: String, nationality: String, neighborhood: String, occupation: String, rg: String, state: String, telephone: String) {
		self.address = address
		self.addressNumber = addressNumber
		self.affiliation = affiliation
		self.age = age
		self.birthDate = birthDate
		self.cellphone = cellphone
		self.cep = cep
		self.city = city
		self.complement = complement
		self.cpf = cpf
		self.createdAt = createdAt
		self.email = email
		self.id = id
		self.maritalStatus = maritalStatus
		self.name = name
		self.nationality = nationality
		self.neighborhood = neighborhood
		self.occupation = occupation
		self.rg = rg
		self.rootFolder = Folder(createdAt: Date.now, name: "root\(name)")
		self.state = state
		self.telephone = telephone
		self.recordName = nil
	}
	
	init(_ record: CKRecord) async {
		// Valores obrigatórios com fallback (valores padrões)
		if let address = record[ClientFields.address.rawValue] as? String {
			self.address = address
		} else {
			print("Missing required field: address")
			self.address = "Unknown Address"
		}
		
		if let addressNumber = record[ClientFields.addressNumber.rawValue] as? String {
			self.addressNumber = addressNumber
		} else {
			print("Missing required field: addressNumber")
			self.addressNumber = "Unknown Number"
		}
		
		if let affiliation = record[ClientFields.affiliation.rawValue] as? String {
			self.affiliation = affiliation
		} else {
			print("Missing required field: affiliation")
			self.affiliation = "No Affiliation"
		}
		
		if let age = record[ClientFields.age.rawValue] as? Int64 {
			self.age = age
		} else {
			print("Missing required field: age")
			self.age = 0
		}
		
		if let birthDate = record[ClientFields.birthDate.rawValue] as? Date {
			self.birthDate = birthDate
		} else {
			print("Missing required field: birthDate")
			self.birthDate = Date()
		}
		
		if let cellphone = record[ClientFields.cellphone.rawValue] as? String {
			self.cellphone = cellphone
		} else {
			print("Missing required field: cellphone")
			self.cellphone = "Unknown Cellphone"
		}
		
		if let cep = record[ClientFields.cep.rawValue] as? String {
			self.cep = cep
		} else {
			print("Missing required field: cep")
			self.cep = "00000-000"
		}
		
		if let city = record[ClientFields.city.rawValue] as? String {
			self.city = city
		} else {
			print("Missing required field: city")
			self.city = "Unknown City"
		}
		
		if let complement = record[ClientFields.complement.rawValue] as? String {
			self.complement = complement
		} else {
			print("Missing required field: complement")
			self.complement = ""
		}
		
		if let cpf = record[ClientFields.cpf.rawValue] as? String {
			self.cpf = cpf
		} else {
			print("Missing required field: cpf")
			self.cpf = "000.000.000-00"
		}
		
		if let email = record[ClientFields.email.rawValue] as? String {
			self.email = email
		} else {
			print("Missing required field: email")
			self.email = "unknown@email.com"
		}
		
		if let id = record[ClientFields.id.rawValue] as? String {
			self.id = id
		} else {
			print("Missing required field: id")
			self.id = UUID().uuidString
		}
		
		if let maritalStatus = record[ClientFields.maritalStatus.rawValue] as? String {
			self.maritalStatus = maritalStatus
		} else {
			print("Missing required field: maritalStatus")
			self.maritalStatus = "Unknown"
		}
		
		if let name = record[ClientFields.name.rawValue] as? String {
			self.name = name
		} else {
			print("Missing required field: name")
			self.name = "Unknown Name"
		}
		
		if let nationality = record[ClientFields.nationality.rawValue] as? String {
			self.nationality = nationality
		} else {
			print("Missing required field: nationality")
			self.nationality = "Unknown Nationality"
		}
		
		if let occupation = record[ClientFields.occupation.rawValue] as? String {
			self.occupation = occupation
		} else {
			print("Missing required field: occupation")
			self.occupation = "Unemployed"
		}
		
		if let rg = record[ClientFields.rg.rawValue] as? String {
			self.rg = rg
		} else {
			print("Missing required field: rg")
			self.rg = "Unknown RG"
		}
		
		if let rootFolder = record[ClientFields.rootFolder.rawValue] as? CKRecord.Reference {
			do {
				if let folderRecord = try await CloudManager.getRecordFromReference(rootFolder) {
					let folderObject = await Folder(folderRecord)
					self.rootFolder = folderObject
				}
			} catch {
				print("Root folder could not be converted to a Folder object")
			}
		} else {
			print("Missing required field: rootFolder")
			// Como rootFolder é obrigatório, defina um valor default, ou outro tratamento
			self.rootFolder = Folder(createdAt: Date.now, name: "Error")
			fatalError("Root folder is required")
		}
		
		if let state = record[ClientFields.state.rawValue] as? String {
			self.state = state
		} else {
			print("Missing required field: state")
			self.state = "Unknown State"
		}
		
		if let telephone = record[ClientFields.telephone.rawValue] as? String {
			self.telephone = telephone
		} else {
			print("Missing required field: telephone")
			self.telephone = "Unknown Telephone"
		}
		
		if let createdAt = record[ClientFields.createdAt.rawValue] as? Date {
			self.createdAt = createdAt
		} else {
			print("Missing required field: createdAt")
			self.createdAt = Date.now
		}
		
		if let neighborhood = record[ClientFields.neighborhood.rawValue] as? String {
			self.neighborhood = neighborhood
		} else {
			print("Missing required field: neighborhood")
			self.neighborhood = "Unknown neighborhood"
		}
		
		self.recordName = record.recordID.recordName
	}
}
