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
	let recordManager: RecordManager
	let cloudDataConverter: CloudDataConverter
	let context: NSManagedObjectContext
	
	var office: Office? = nil
	
	// MARK: - Na implementação de mais modelos, será necessário fazer um array de "current{model}", atualizar a func `updateArrays` e o enum `QueryType`
	// MARK: Além de atualizar a função `makeObjectsFromRecords` do recordObjectManager para lidar com outros tipos de objeto.
	@Published var currentFiles: [Recordable] = []
	@Published var currentFolders: [Recordable] = []
	@Published var currentClients: [Recordable] = []
	
	@Published var loading = false
	
	init(container: CKContainer, cloudDataConverter: CloudDataConverter, context: NSManagedObjectContext) {
		self.container = container
		CloudManager.publicDataBase = container.publicCloudDatabase
		self.recordManager = RecordManager(container: container, context: context)
		self.cloudDataConverter = cloudDataConverter
		self.context = context
	}
	
	public static func getRecordFromReference(_ reference: CKRecord.Reference, completion: @escaping (CKRecord?, Error?) -> Void) {
		let recordID = reference.recordID
		
		self.publicDataBase.fetch(withRecordID: recordID) { record, error in
			completion(record, error)
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
			officeToReturn = Office(officeReturnedRecord, context: context)
			officeToReturn?.record = officeReturnedRecord
		} catch {
			print("Could not save officeRecord")
		}
		
		return officeToReturn
	}
	
	func getUserOfficeFrom(officeID: String) async -> Office? {  // MARK: Quero que este officeID seja o CKRecord.RecordID do office
		do {
			let officeRecord = try await CloudManager.publicDataBase.record(for: CKRecord.ID(recordName: officeID))
			let officeObj = Office(officeRecord, context: context)
			self.office = officeObj
			return officeObj
		} catch {
			print("No office with ID \(officeID) found: \(error)")
			return nil
		}
	}
	
	
}



