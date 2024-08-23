//
//  CloudManager.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import CloudKit

protocol Recordable {
	var record: CKRecord? { get set }
}

class CloudManager {
	
	let container: CKContainer
	let publicDatabase: CKDatabase
	
	init(container: CKContainer) {
		self.container = container
		publicDatabase = container.publicCloudDatabase
	}
	
	deinit {
		print("See you next time!")
	}
	
	func saveObject<T: Recordable>(object: inout T) async {
		let m3 = Mirror(reflecting: object)
		let className = String(describing: type(of: object))
		
		// MARK: Precisa ser tratado para não deixar qualquer objeto ser criado
		let record = CKRecord(recordType: "\(className)")
		
		for (property, value) in m3.children {
			guard let property = property
			else {
				print("No property")
				continue
			}
			// property & value
			if let value = value as? Optional<Any> {
				if let actualValue = value {
					record.setValue(actualValue, forKey: "\(property)")
				}
			}
			
		}
		print(m3.children.count)
		record.setValue(Date.now, forKey: "createdAt")
		
		do {
			let savedRecord = try await publicDatabase.save(record)
			// MARK: É bom ter o modelo com um atributo de CKRecord e atribuir o savedRecord a esse atributo
			object.record = savedRecord
		} catch {
			print("Error saving object of type (\(className)): \(error)")
		}
	}
	
	
	func fetchWithQuery(_ query: CKQuery) async -> [CKRecord]? {
		
		do {
			let result = try await publicDatabase.records(matching: query)
			let records = try result.matchResults.compactMap { try $0.1.get() }
			// Caso não for genérico, aqui inicializar os modelos e retorná-los
			return records
		} catch {
			print("Error fetching from CloudKit: \(error)")
		}
		
		return nil
	}
	
	
	func updateRecordWithID<T: Any>(object: T, key: String, newValue: Any) async {
		
		let record = getRecord(object: object)
		
		let className = String(describing: type(of: object))
		
		print(className)
		
		if let record = record {
			do {
				let record = try await publicDatabase.record(for: record.recordID)
				record[key] = newValue as? CKRecordValue
			} catch {
				print("Error updating record of type \(className): \(error)")
			}
		} else {
			return
		}
	}
	
	func deleteObject(object: Any) async {
		let record = getRecord(object: object)
		
		if let record = record {
			do {
				try await publicDatabase.deleteRecord(withID: record.recordID)
			} catch {
				print("Error deleting object: \(error)")
			}
		}
	}
	
	
//	func getID(object: Any) -> CKRecord.ID? {
//		let m3 = Mirror(reflecting: object)
//
//		var id: String? = nil
//		for (property, value) in m3.children {
//			guard let property = property
//			else {
//				print("No property")
//				continue
//			}
//			if property == "RecordID" {
//				id = value as? String
//				break
//			}
//		}
//		if let id = id {
//			return CKRecord.ID(recordName: id)
//		}
//		return nil
//	}
	
	
	func getRecord(object: Any) -> CKRecord? {
		let m3 = Mirror(reflecting: object)

		var record: CKRecord? = nil
		for (property, value) in m3.children {
			guard let property = property
			else {
				print("No property")
				continue
			}
			if property == "record" {
				record = value as? CKRecord
				break
			}
		}
		return record
	}
	
	
}
