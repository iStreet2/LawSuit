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
    var context: NSManagedObjectContext
    
    init(container: CKContainer, context: NSManagedObjectContext) {
        self.container = container
        self.publicDatabase = container.publicCloudDatabase
        self.context = context
    }
    
    deinit {
        print("See you next time!")
    }
    
    func saveContext() {
        do {
            try self.context.save()
        } catch {
            print("Error saving context on RecordManager: \(error)")
        }
    }
    
    // MARK: - Fetch
    func fetchWithQuery(_ query: CKQuery) async -> [CKRecord]? {
        //let query = CKQuery(recordType: "Folder", predicate: NSPredicate(format: "TRUEPREDICATE"))
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
        for (index, propertyName) in propertyNames.enumerated() {
            let newValue = propertyValues[index]
            updatedFields[propertyName] = newValue
        }
        guard let recordName = object.value(forKey: "recordName") as? String else {
            print("Error: recordName is missing from the object.")
            return
        }
        let recordID = CKRecord.ID(recordName: recordName)
        let record = try await self.publicDatabase.record(for: recordID)
        for (key, value) in updatedFields {
            record.setValue(value, forKey: key)
        }
        try await self.publicDatabase.save(record)
    }
    
    //MARK: Delete
    func deleteObjectInCloudKit<T: NSManagedObject>(object: T, relationshipsToDelete: [String] = []) async throws {
        guard let recordName = object.value(forKey: "recordName") as? String else {
            print("Error: recordName is missing.")
            return
        }
        for relationshipName in relationshipsToDelete {
            if relationshipName == "rootFolder" {
                if let rootFolder = object.value(forKey: relationshipName) as? NSManagedObject {
                    try await deleteFolderRecursivelyInCloudKit(folder: rootFolder)
                }
            }
            else if let relatedObjects = object.value(forKey: relationshipName) as? NSSet {
                for relatedObject in relatedObjects {
                    if let relatedObject = relatedObject as? NSManagedObject {
                        try await deleteObjectInCloudKit(object: relatedObject, relationshipsToDelete: [])
                    }
                }
            }
            else if let relatedObject = object.value(forKey: relationshipName) as? NSManagedObject {
                try await deleteObjectInCloudKit(object: relatedObject, relationshipsToDelete: [])
            }
        }
        let recordID = CKRecord.ID(recordName: recordName)
        do {
            try await publicDatabase.deleteRecord(withID: recordID)
        } catch {
            throw error
        }
    }
    
    func deleteLawsuitOrClientWithRecordName(recordName: String, rootFolder: Folder) async throws {
        let recordID = CKRecord.ID(recordName: recordName)
        try await deleteFolderRecursivelyInCloudKit(folder: rootFolder)
        do {
            try await publicDatabase.deleteRecord(withID: recordID)
        } catch {
            throw error
        }
    }
    
    func deleteObjectWithRecordName(recordName: String) async throws {
        let recordID = CKRecord.ID(recordName: recordName)
        do {
            try await publicDatabase.deleteRecord(withID: recordID)
        } catch {
            throw error
        }
    }
    
    func deleteFolderRecursivelyInCloudKit(folder: NSManagedObject) async throws {
        if let subfolders = folder.value(forKey: "folders") as? NSSet {
            for subfolder in subfolders {
                if let subfolderObject = subfolder as? NSManagedObject {
                    // Recursivamente deletar a subpasta
                    try await deleteFolderRecursivelyInCloudKit(folder: subfolderObject)
                }
            }
        }
        if let files = folder.value(forKey: "files") as? NSSet {
            for file in files {
                if let fileObject = file as? NSManagedObject {
                    // Deletar o arquivo no CloudKit
                    try await deleteObjectInCloudKit(object: fileObject, relationshipsToDelete: [])
                }
            }
        }
        try await deleteObjectInCloudKit(object: folder)
    }
    
    func deleteFolderRecursivelyInCloudKit(recordName: String) async throws {
        // Criar o ID do registro da pasta no CloudKit
        let folderRecordID = CKRecord.ID(recordName: recordName)

        // Buscar a pasta no CloudKit
        let folderRecord = try await publicDatabase.record(for: folderRecordID)

        // Verificar se a pasta possui subpastas (folders)
        if let subfolderReferences = folderRecord["folders"] as? [CKRecord.Reference] {
            for subfolderReference in subfolderReferences {
                // Pegar o recordName da subpasta e deletar recursivamente
                let subfolderRecordID = subfolderReference.recordID
                try await deleteFolderRecursivelyInCloudKit(recordName: subfolderRecordID.recordName)
            }
        }

        // Verificar se a pasta possui arquivos (files)
        if let fileReferences = folderRecord["files"] as? [CKRecord.Reference] {
            for fileReference in fileReferences {
                // Pegar o recordName do arquivo e deletar
                let fileRecordID = fileReference.recordID
                try await publicDatabase.deleteRecord(withID: fileRecordID)
            }
        }

        // Finalmente, deletar a própria pasta
        try await publicDatabase.deleteRecord(withID: folderRecordID)
    }
    
    //MARK: Função para remover uma referencia
    func removeReference<T: NSManagedObject>(from firstObject: T, to secondObject: T, referenceKey: String) async throws {
        guard let firstRecordName = firstObject.value(forKey: "recordName") as? String else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "First object not found in CloudKit"])
        }

        guard let secondRecordName = secondObject.value(forKey: "recordName") as? String else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Second object not found in CloudKit"])
        }

        let secondRecordID = CKRecord.ID(recordName: secondRecordName)
        let firstRecordID = CKRecord.ID(recordName: firstRecordName)
        let firstRecord = try await publicDatabase.record(for: firstRecordID)

        let relationships = firstObject.entity.relationshipsByName
        if let _ = relationships[referenceKey] {
            if var references = firstRecord[referenceKey] as? [CKRecord.Reference] {
                references.removeAll { $0.recordID == secondRecordID }
                firstRecord[referenceKey] = references.isEmpty ? nil : references as CKRecordValue
            } else {
                throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No references found for \(referenceKey)"])
            }
        } else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Relationship \(referenceKey) not found"])
        }

        try await publicDatabase.save(firstRecord)
    }
    
    func removeReference(from firstRecordName: String, to secondRecordName: String, referenceKey: String) async throws {
        // Criar os IDs dos registros no CloudKit
        let firstRecordID = CKRecord.ID(recordName: firstRecordName)
        let secondRecordID = CKRecord.ID(recordName: secondRecordName)

        // Buscar o primeiro registro (de onde queremos remover a referência)
        let firstRecord = try await publicDatabase.record(for: firstRecordID)

        // Verificar se há referências na chave fornecida
        if var references = firstRecord[referenceKey] as? [CKRecord.Reference] {
            // Remover a referência correspondente ao secondRecordID
            references.removeAll { $0.recordID == secondRecordID }
            
            // Se o array de referências estiver vazio, podemos removê-lo ou definir como `nil`
            firstRecord[referenceKey] = references.isEmpty ? nil : references as CKRecordValue
            
            // Salvar o registro atualizado no CloudKit
            try await publicDatabase.save(firstRecord)
        } else {
            throw NSError(domain: "CloudKitError", code: 0, userInfo: [NSLocalizedDescriptionKey: "No references found for \(referenceKey)"])
        }
    }
    
}


