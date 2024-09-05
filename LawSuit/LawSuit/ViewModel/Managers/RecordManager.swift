//
//  CloudManager.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import CloudKit
import CoreData
import PDFKit

protocol Recordable {
	var recordName: String? { get set }
}

class RecordManager {
	
    let container: CKContainer
    let publicDatabase: CKDatabase
    
    init(container: CKContainer) {
        self.container = container
        publicDatabase = container.publicCloudDatabase
    }
    
    deinit {
        print("See you next time!")
    }
    
    
    // MARK: - Save
    func saveObject<T: Recordable>(object: inout T) async {
        let className = String(describing: type(of: object))
        let record = CKRecord(recordType: "\(className)")
        
        if let managedObject = object as? NSManagedObject {
            let attributes = managedObject.entity.attributesByName
            
            // Save attributes
            for (attributeName, _) in attributes {
                if let value = managedObject.value(forKey: attributeName) {
                    if attributeName == "content" {
                        if let data = value as? Data {
                            let pdfData = PDFDocument(data: data)
                            if let pdfURL = pdfData?.documentURL {
                                let asset = CKAsset(fileURL: pdfURL)
                                record.setValue(asset, forKey: attributeName)
                            }
                        }
                    } else {
                        record.setValue(value, forKey: attributeName)
                    }
                }
            }
        }
        
        record.setValue(Date.now, forKey: "createdAt")
        
        do {
            let savedRecord = try await publicDatabase.save(record)
            object.recordName = savedRecord.recordID.recordName
            
            // Save related objects and update the relationships
            await saveRelatedObjects(for: object)
            await saveRelationships(for: object)
            
        } catch {
            print("Error saving object of type (\(className)): \(error)")
        }
    }
    //Do jeito que esta a função está todas relações sao enviadas, inclusive as parents
    private func saveRelatedObjects<T: Recordable>(for object: T) async {
        if let managedObject = object as? NSManagedObject {
            let relationships = managedObject.entity.relationshipsByName
            
            for (relationshipName, relationshipDescription) in relationships {
                if relationshipDescription.isToMany {
                    // Lida com relacionamentos to-many
                    if let relatedObjects = managedObject.value(forKey: relationshipName) as? NSSet {
                        for relatedObject in relatedObjects {
                            if let relatedManagedObject = relatedObject as? NSManagedObject,
                               relatedManagedObject.value(forKey: "recordName") == nil {
                                var relatedRecordable = relatedManagedObject as! Recordable
                                await saveObject(object: &relatedRecordable)
                            }
                        }
                    }
                } else {
                    // Lida com relacionamentos to-one
                    if let relatedObject = managedObject.value(forKey: relationshipName) as? NSManagedObject,
                       relatedObject.value(forKey: "recordName") == nil {
                        var relatedRecordable = relatedObject as! Recordable
                        await saveObject(object: &relatedRecordable)
                    }
                }
            }
            
        }
    }
    
    //Do jeito que esta a função está todas relações sao enviadas, inclusive as parents
    private func saveRelationships<T: Recordable>(for object: T) async {
        if let managedObject = object as? NSManagedObject {
            let relationships = managedObject.entity.relationshipsByName
            
            // Fetch the CKRecord associated with this object
            guard let recordName = object.recordName else { return }
            let recordID = CKRecord.ID(recordName: recordName)
            
            do {
                let record = try await publicDatabase.record(for: recordID)
                
                for (relationshipName, relationshipDescription) in relationships {
                    if relationshipDescription.isToMany {
                        // Relationship is to-many, handle as NSSet
                        if let value = managedObject.value(forKey: relationshipName) as? NSSet {
                            let relatedRecords = value.compactMap { relatedObject -> CKRecord.Reference? in
                                if let relatedManagedObject = relatedObject as? NSManagedObject,
                                   let relatedRecordName = relatedManagedObject.value(forKey: "recordName") as? String {
                                    let relatedRecordID = CKRecord.ID(recordName: relatedRecordName)
                                    return CKRecord.Reference(recordID: relatedRecordID, action: .none)
                                }
                                return nil
                            }
                            // Only add the reference if there are related records
                            if !relatedRecords.isEmpty {
                                record.setValue(relatedRecords, forKey: relationshipName)
                            }
                        }
                    } else {
                        // Relationship is to-one, handle as a single object
                        if let relatedObject = managedObject.value(forKey: relationshipName) as? NSManagedObject,
                           let relatedRecordName = relatedObject.value(forKey: "recordName") as? String {
                            let relatedRecordID = CKRecord.ID(recordName: relatedRecordName)
                            let relatedRecordReference = CKRecord.Reference(recordID: relatedRecordID, action: .none)
                            record.setValue(relatedRecordReference, forKey: relationshipName)
                        }
                    }
                }
                
                // Save the updated record with relationships
                try await publicDatabase.save(record)
                
            } catch {
                print("Error saving relationships for object of type \(String(describing: type(of: object)))): \(error)")
            }
        }
    }
    
    
    // MARK: - Fetch
    func fetchWithQuery(_ query: CKQuery) async -> [CKRecord]? {
        
        //		let query = CKQuery(recordType: "Folder", predicate: NSPredicate(format: "TRUEPREDICATE"))
        
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
    
    // MARK: - Update
    func updateRecordWithID<T: Any>(object: T, key: String, newValue: Any) async {
        
        let record = getRecord(object: object)
        
        let className = String(describing: type(of: object))
        
        print(className)
        
        if let record = record {
            do {
                let record = try await publicDatabase.record(for: record.recordID)
                record[key] = newValue as? CKRecordValue
                try await publicDatabase.save(record)
            } catch {
                print("Error updating record of type \(className): \(error)")
            }
        } else {
            return
        }
    }
    
    // MARK: - Delete
    func deleteObject(object: Recordable) async {
        let recordName = object.recordName
        
        if let recordName = recordName {
            do {
                try await publicDatabase.deleteRecord(withID: CKRecord.ID(recordName: recordName))
            } catch {
                print("Error deleting object: \(error)")
            }
        }
    }
    
    func getRecord(object: Any) -> CKRecord? {
        let m3 = Mirror(reflecting: object)
        
        var record: CKRecord? = nil
        for (property, value) in m3.children {
            guard let property = property
            else {
                print("No property")
                continue
            }
            if property == "recordName" {
                record = value as? CKRecord
                break
            }
        }
        return record
    }
    
	
}
