//
//  Office.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/09/24.
//
import Foundation
import CloudKit
import CoreData

class Office: Identifiable {
	let id = UUID()
	var clients: [Client] = []
	var lawsuits: [Lawsuit] = []
	var lawyers: [Lawyer] = []
	var name: String
	var owner: Lawyer?
	var record: CKRecord?
	var context: NSManagedObjectContext
	
	init(clients: [Client] = [], lawsuits: [Lawsuit] = [], lawyers: [Lawyer], name: String, owner: Lawyer, record: CKRecord? = nil, context: NSManagedObjectContext) {
		self.clients = clients
		self.lawsuits = lawsuits
		self.lawyers = lawyers
		self.name = name
		self.owner = owner
		self.record = record
		self.context = context
	}
	
	init?(_ record: CKRecord, context: NSManagedObjectContext) {
		guard
			let name = record[OfficeFields.name.rawValue] as? String,
			let clients = record[OfficeFields.clients.rawValue] as? [CKRecord.Reference],
			let lawsuits = record[OfficeFields.lawsuits.rawValue] as? [CKRecord.Reference],
			let lawyers = record[OfficeFields.lawyers.rawValue] as? [CKRecord.Reference],
			let owner = record[OfficeFields.owner.rawValue] as? CKRecord.Reference
		else { print("Failed initializing Office from record"); return nil }
		
		self.name = name
		self.context = context
		
		// Fetch clients asynchronously
		for client in clients {
			CloudManager.getRecordFromReference(client) { record, error in
				if let record = record {
					if let clientObject = Client(record, context: context) {
						self.clients.append(clientObject)
					}
				} else {
					print("Could not retrieve client record from reference")
				}
			}
		}
		
		// Fetch lawsuits asynchronously
		for lawsuit in lawsuits {
			CloudManager.getRecordFromReference(lawsuit) { record, error in
				if let record = record {
					if let lawsuitObject = Lawsuit(record, context: context) {
						self.lawsuits.append(lawsuitObject)
					}
				} else {
					print("Could not retrieve lawsuit record from reference")
				}
			}
		}
		
		// Fetch lawyers asynchronously
		for lawyer in lawyers {
			CloudManager.getRecordFromReference(lawyer) { record, error in
				if let record = record {
					if let lawyerObject = Lawyer(record, context: context) {
						self.lawyers.append(lawyerObject)
					}
				} else {
					print("Could not retrieve lawyer record from reference")
				}
			}
		}
		
		// Fetch owner asynchronously
		CloudManager.getRecordFromReference(owner) { record, error in
			if let record = record {
				if let ownerObject = Lawyer(record, context: context) {
					self.owner = ownerObject
				}
			} else {
				print("Could not retrieve owner record from reference")
			}
		}
	}
}