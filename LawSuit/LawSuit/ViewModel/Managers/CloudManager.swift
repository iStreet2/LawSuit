//
//  CloudManager.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import CloudKit
import CoreData

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
	
    func saveObject<T: Any>(object: inout T) async {
        let className = String(describing: type(of: object))
        let record = CKRecord(recordType: "\(className)")
        
        if let managedObject = object as? NSManagedObject {
            let attributes = managedObject.entity.attributesByName
            for (attributeName, _) in attributes {
                if let value = managedObject.value(forKey: attributeName) {
                    record.setValue(value, forKey: attributeName)
                }
            }
        } else {
            let mirror = Mirror(reflecting: object)
            for (property, value) in mirror.children {
                guard let property = property else {
                    print("No property")
                    continue
                }
                if let value = value as? Optional<Any> {
                    if let actualValue = value {
                        record.setValue(actualValue, forKey: "\(property)")
                    }
                }
            }
        }
        
        record.setValue(Date.now, forKey: "createdAt")
        
        do {
            let savedRecord = try await publicDatabase.save(record)
            if let managedObject = object as? Client {
                managedObject.recordName = savedRecord.recordID.recordName
            }
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
