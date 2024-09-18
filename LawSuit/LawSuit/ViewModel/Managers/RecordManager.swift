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
    let context: NSManagedObjectContext
    
    init(container: CKContainer, context: NSManagedObjectContext) {
        self.container = container
        self.publicDatabase = container.publicCloudDatabase
        self.context = context
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
    func updateRecordWithID<T: Recordable>(object: T, key: String, newValue: Any) async {
        
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
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error saving context on RecordManager: \(error)")
        }
    }

    
    //MARK: Novas funções para teste!
    
    //MARK: - Create: Nessa função basta passar o objeto e um vetor com strings escrito o nome dos relationShips que você quer salvar
    func saveObject<T: Recordable>(object: inout T, relationshipsToSave: Set<String>) async throws {
        let className = String(describing: type(of: object))
        let record = CKRecord(recordType: className)
        
        if let managedObject = object as? NSManagedObject {
            let attributes = managedObject.entity.attributesByName
            let relationships = managedObject.entity.relationshipsByName
            
            // Save attributes
            for (attributeName, _) in attributes {
                if let value = managedObject.value(forKey: attributeName) {
                    if attributeName == "content" {
                        if let data = value as? Data {
                            // Handle PDF data saving logic
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
            
            // Save specified relationships (//Reference)
            for (relationshipName, _) in relationships {
                if relationshipsToSave.contains(relationshipName), let relatedObject = managedObject.value(forKey: relationshipName) as? NSManagedObject {
                    if let recordName = relatedObject.value(forKey: "recordName") as? String {
                        let relatedRecordID = CKRecord.ID(recordName: recordName)
                        let reference = CKRecord.Reference(recordID: relatedRecordID, action: .none)
                        record.setValue(reference, forKey: relationshipName)
                    }
                }
            }
        }
        
        record.setValue(Date(), forKey: "createdAt")
        
        do {
            let savedRecord = try await publicDatabase.save(record)
            object.recordName = savedRecord.recordID.recordName
            saveContext()
        } catch {
            throw error
        }
    }
    
    //MARK: Essa função adiciona no CloudKit uma reference do primeiro objeto para o segundo
    func addReference<T: NSManagedObject>(from firstObject: T, to secondObject: T, referenceKey: String) async throws {
        guard let firstRecordName = firstObject.value(forKey: "recordName") as? String else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "First object not found in CloudKit"])
        }
        
        guard let secondRecordName = secondObject.value(forKey: "recordName") as? String else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Second object not found in CloudKit"])
        }
        let secondRecordID = CKRecord.ID(recordName: secondRecordName)
        let secondReference = CKRecord.Reference(recordID: secondRecordID, action: .none)
        
        let firstRecordID = CKRecord.ID(recordName: firstRecordName)
        let firstRecord = try await publicDatabase.record(for: firstRecordID)
        
        let relationships = firstObject.entity.relationshipsByName
        
        if let _ = relationships[referenceKey] {
            var references = firstRecord[referenceKey] as? [CKRecord.Reference] ?? []
            references.append(secondReference)
            firstRecord[referenceKey] = references as CKRecordValue
        } else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Relationship \(referenceKey) not found"])
        }
        
        try await publicDatabase.save(firstRecord)
    }
    
    //MARK: - Update de um objeto passando várias propriedades
    func updateObjectInCloudKit<T: NSManagedObject>(object: T, propertyNames: [String], propertyValues: [Any]) async throws {
        guard propertyNames.count == propertyValues.count else {
            print("Error: The count of property names and property values does not match.")
            return
        }
        
        var updatedFields = [String: Any]()
        
        // Cria o dicionário de campos modificados
        for (index, propertyName) in propertyNames.enumerated() {
            let newValue = propertyValues[index]
            updatedFields[propertyName] = newValue
        }
        
        // Atualizar no CloudKit
        guard let recordName = object.value(forKey: "recordName") as? String else {
            print("Error: recordName is missing from the object.")
            return
        }
        
        let recordID = CKRecord.ID(recordName: recordName)
        let record = try await self.publicDatabase.record(for: recordID)
        
        // Atualiza os campos no CKRecord
        for (key, value) in updatedFields {
            record.setValue(value, forKey: key)
        }
        
        // Salva as mudanças no CloudKit
        try await self.publicDatabase.save(record)
    }
    
    //MARK: Delete
    func deleteObjectInCloudKit<T: NSManagedObject>(object: T, relationshipsToDelete: [String] = []) async throws {
        // Verificar se o objeto tem um recordName para localizar no CloudKit
        guard let recordName = object.value(forKey: "recordName") as? String else {
            print("Error: recordName is missing.")
            return
        }
        
        // Deletar os relacionamentos especificados no CloudKit
        for relationshipName in relationshipsToDelete {
            // Se a relação é uma rootFolder, deletar suas subpastas e arquivos recursivamente
            if relationshipName == "rootFolder" {
                if let rootFolder = object.value(forKey: relationshipName) as? NSManagedObject {
                    try await deleteFolderRecursivelyInCloudKit(folder: rootFolder)
                }
            }
            // Caso o relacionamento seja um NSSet (to-many)
            else if let relatedObjects = object.value(forKey: relationshipName) as? NSSet {
                for relatedObject in relatedObjects {
                    if let relatedObject = relatedObject as? NSManagedObject {
                        // Deletar o objeto relacionado diretamente no CloudKit
                        try await deleteObjectInCloudKit(object: relatedObject, relationshipsToDelete: [])
                    }
                }
            }
            // Caso o relacionamento seja um NSManagedObject (to-one)
            else if let relatedObject = object.value(forKey: relationshipName) as? NSManagedObject {
                // Deletar o objeto relacionado diretamente no CloudKit
                try await deleteObjectInCloudKit(object: relatedObject, relationshipsToDelete: [])
            }
        }
        
        // Deletar o objeto no CloudKit
        let recordID = CKRecord.ID(recordName: recordName)
        do {
            try await publicDatabase.deleteRecord(withID: recordID)
        } catch {
            throw error
        }
    }
    
    // Função para deletar pastas e seus conteúdos recursivamente
    func deleteFolderRecursivelyInCloudKit(folder: NSManagedObject) async throws {
        // Verificar se a pasta possui subpastas
        if let subfolders = folder.value(forKey: "folders") as? NSSet {
            for subfolder in subfolders {
                if let subfolderObject = subfolder as? NSManagedObject {
                    // Recursivamente deletar a subpasta
                    try await deleteFolderRecursivelyInCloudKit(folder: subfolderObject)
                }
            }
        }
        
        // Verificar se a pasta possui arquivos
        if let files = folder.value(forKey: "files") as? NSSet {
            for file in files {
                if let fileObject = file as? NSManagedObject {
                    // Deletar o arquivo no CloudKit
                    try await deleteObjectInCloudKit(object: fileObject, relationshipsToDelete: [])
                }
            }
        }
        
        // Finalmente, deletar a própria pasta
        try await deleteObjectInCloudKit(object: folder)
    }
    
    //MARK: Função para remover uma referencia
    func removeReference<T: NSManagedObject>(from firstObject: T, to secondObject: T, referenceKey: String) async throws {
        // Verificar se os objetos possuem recordName
        guard let firstRecordName = firstObject.value(forKey: "recordName") as? String else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "First object not found in CloudKit"])
        }

        guard let secondRecordName = secondObject.value(forKey: "recordName") as? String else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Second object not found in CloudKit"])
        }

        // Obter os IDs de ambos os objetos
        let secondRecordID = CKRecord.ID(recordName: secondRecordName)
        let firstRecordID = CKRecord.ID(recordName: firstRecordName)
        let firstRecord = try await publicDatabase.record(for: firstRecordID)

        // Verificar se a relação existe
        let relationships = firstObject.entity.relationshipsByName
        if let _ = relationships[referenceKey] {
            // Obter o array de referências existente e remover a que corresponde ao secondObject
            if var references = firstRecord[referenceKey] as? [CKRecord.Reference] {
                references.removeAll { $0.recordID == secondRecordID }
                firstRecord[referenceKey] = references.isEmpty ? nil : references as CKRecordValue
            } else {
                throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No references found for \(referenceKey)"])
            }
        } else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Relationship \(referenceKey) not found"])
        }

        // Salvar as mudanças no CloudKit
        try await publicDatabase.save(firstRecord)
    }
    
}


