//
//  CloudViewModel.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import CloudKit
import CoreData

class CloudManager: ObservableObject {
	let container: CKContainer
	static var publicDataBase = CKContainer.default().publicCloudDatabase // TODO: Talvez dê errado isso aqui
	
    @Published var loading = false
	
	init(container: CKContainer) {
		self.container = container
		CloudManager.publicDataBase = container.publicCloudDatabase
	}
    
	public static func getRecordFromReference(_ reference: CKRecord.Reference) async throws -> CKRecord? {
		let recordID = reference.recordID
		return try await withCheckedThrowingContinuation { continuation in
			self.publicDataBase.fetch(withRecordID: recordID) { record, error in
				if let error = error {
					continuation.resume(throwing: error)
				} else {
					continuation.resume(returning: record)
				}
			}
		}
	}
	
	public func getObjectsWith(query: QueryType) async -> [Recordable] {
		self.loading = true
		
		if let records = await recordManager.fetchWithQuery(query.query) {
			if let objects = await cloudDataConverter.makeObjectsFromRecords(records: records) {
				updateArrays(query: query, objects: objects)
				self.loading = false
				return objects
			} else {
				print("Couldn't retrieve objects")
			}
		} else {
			print("Couldn't retrieve records")
		}
		
		updateArrays(query: query)
		self.loading = false
		return []
	}
	
	private func updateArrays(query: QueryType, objects: [any Recordable] = []) {
		
		let updateDict: [QueryType: (Array<any Recordable>) -> Void] = [
			.file: { self.currentFiles = $0 },
			.client: { self.currentClients = $0 },
			.folder: { self.currentFolders = $0 }
		]
		
		updateDict[query]?(objects)
	}
	
	public func emptyAllArrays(areYouSure: Bool) {
		if areYouSure {
			print("Goodbye...")
			self.currentFiles = []
			self.currentClients = []
			self.currentFolders = []
		}
	}
	
	func createOffice(name: String, lawyer: Lawyer) async -> Office? {
		let ownerRecord = CKRecord(recordType: "Lawyer")
		
		ownerRecord.setValue(lawyer.name, forKey: LawyerFields.name.rawValue)
		ownerRecord.setValue(lawyer.email, forKey: LawyerFields.email.rawValue)
		ownerRecord.setValue(lawyer.username, forKey: LawyerFields.username.rawValue)
		//		ownerRecord.setValue(lawyer., forKey: LawyerFields.username.rawValue)
		
		var ownerReference: CKRecord.Reference = CKRecord.Reference(record: ownerRecord, action: .none)
		
		do {
			let ownerReturnedRecord = try await CloudManager.publicDataBase.save(ownerRecord)
			lawyer.recordName = ownerReturnedRecord.recordID.recordName
			try context.save()
			
			ownerReference = CKRecord.Reference(record: ownerReturnedRecord, action: .none)
		} catch {
			print("Could not save ownerRecord")
		}
		
		let officeRecord = CKRecord(recordType: "Office")
		
		officeRecord.setValue([lawyer.email], forKey: OfficeFields.lawyers.rawValue)
		officeRecord.setValue(name, forKey: OfficeFields.name.rawValue)
		officeRecord.setValue(ownerReference, forKey: OfficeFields.owner.rawValue)
		
		var officeToReturn: Office? = nil
		
		do {
			let officeReturnedRecord = try await CloudManager.publicDataBase.save(officeRecord)
			officeToReturn = await Office(officeReturnedRecord, context: context)
			
			ownerRecord.setValue(officeReturnedRecord.recordID.recordName, forKey: LawyerFields.officeID.rawValue)
			try await CloudManager.publicDataBase.save(ownerRecord)
			
			officeToReturn?.record = officeReturnedRecord
		} catch {
			print("Could not save officeRecord")
		}
		
		return officeToReturn
	}
	
	func getUserOfficeFrom(officeID: String) async -> Office? {  // MARK: Quero que este officeID seja o CKRecord.RecordID do office
		do {
			let officeRecord = try await CloudManager.publicDataBase.record(for: CKRecord.ID(recordName: officeID))
			let officeObj = await Office(officeRecord, context: context)
			
			self.office = officeObj
			return officeObj
		} catch {
			print("No office with ID \(officeID) found: \(error)")
			return nil
		}
	}	
	
	func getUserOfficeFromUserOfficeIDAsCKRecord(user: Lawyer) async -> CKRecord? {
		do {
			if let officeID = user.officeID {
				let officeRecord = try await CloudManager.publicDataBase.record(for: CKRecord.ID(recordName: officeID))
				return officeRecord
			}
			else {
				print("Usuário não possui escritório associado a ele...")
			}
			return nil
		} catch {
			print("Error getting user Office: \(error)")
		}
		return nil
		
	}
	
	func makeRecordFromObject<T: Any>(object: T) -> CKRecord {
		let record = CKRecord(recordType: String(describing: type(of: object)))
		
		let c3 = object
		let m3 = Mirror(reflecting: c3)
		for (property, value) in m3.children {
			guard let property = property else { continue }
			
			print("property: \(property) | value: \(value)")
			
			if property != "recordName" { // -> Isso vai ser atribuído com o retorno do iCloud
				record.setValue(value, forKey: property)
			}
		}
		
		return record
	}
	
	func addClientToOffice(client: CKRecord, user: Lawyer) async -> Office {
		
		/* MARK: Fluxo
		 1. Obtém record de cliente e rootFolder
		 2. salva rootFolder para obter o recordName do iCloud
		 3. atribui a referência do rootFolder ao cliente
		 4. cria uma referência do cliente para ser adicionado ao Office
		 5. Obtém a record de Office
		 6. adiciona a referência do cliente
		 7. salva o Office novamente
		 8. sucesso :thumbs_up:
		 */

		// 4
		let clientReference = CKRecord.Reference(record: client, action: .none)
		
		// 5
		if let officeRecord = await self.getUserOfficeFromUserOfficeIDAsCKRecord(user: user) {
			
			// 6
			if var clientReferences = officeRecord[OfficeFields.clients.rawValue] as? [CKRecord.Reference] {
				clientReferences.append(clientReference)
				
				officeRecord.setValue(clientReferences, forKey: OfficeFields.clients.rawValue)
			} else {
				print("addClientToOffice(): Não foi possível pegar os clientes como [CKRecord.Reference]")
				// MARK: Sobescreve?
				officeRecord.setValue([clientReference], forKey: OfficeFields.clients.rawValue)
			}
			
			
			do {
				// 7
				let returnedOfficeRecord = try await CloudManager.publicDataBase.save(officeRecord)
                if let office = await Office(returnedOfficeRecord) {
                    return office
                }
			} catch {
				print("addClientToOffice(): Could not save office: \(error)")
			}
			
		} else {
			print("addClientToOffice(): Could not get officeRecord whilst trying to add client to office")
		}
		
	}
	
	
}



