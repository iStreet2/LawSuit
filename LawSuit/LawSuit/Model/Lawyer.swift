//
//  Lawyer.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 07/10/24.
//

import Foundation
import CloudKit

class Lawyer {
	var email: String
	var id: String
	var name: String
	var officeID: String // MARK: IMPORTANTE
	var username: String
	
	var recordName: String? // MARK: IMPORTANTE
	
	// MARK: - Init para dentro do código
	init(email: String, id: String, name: String, officeID: String, username: String, recordName: String? = nil) {
		self.email = email
		self.id = id
		self.name = name
		self.officeID = officeID
		self.username = username
		self.recordName = recordName
	}
	
	// MARK: - Init do CloudKit
	init(_ record: CKRecord) {
		if let email = record[LawyerFields.email.rawValue] as? String {
			self.email = email
		} else {
			print("Lawyer missing required field: email")
			self.email = "Unknown email"
		}
		
		if let id = record[LawyerFields.id.rawValue] as? String {
			self.id = id
		} else {
			print("Lawyer missing required field: id")
			self.id = "Unknown id"
		}
		
		if let name = record[LawyerFields.name.rawValue] as? String {
			self.name = name
		} else {
			print("Lawyer missing required field: name")
			self.name = "Unknown name"
		}
		
		if let officeID = record[LawyerFields.officeID.rawValue] as? String {
			self.officeID = officeID
		} else {
			print("Lawyer missing required field: officeID")
			self.officeID = "Unknown officeID"
		}
		
		if let username = record[LawyerFields.username.rawValue] as? String {
			self.username = username
		} else {
			print("Lawyer missing required field: username")
			self.username = "Unknown username"
		}
		
		self.recordName = record.recordID.recordName
	}
}
