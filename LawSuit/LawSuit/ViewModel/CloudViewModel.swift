//
//  CloudViewModel.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import CloudKit

class CloudViewModel: ObservableObject {
	let container: CKContainer
	let publicDatabase: CKDatabase
	let cloudManager: CloudManager
	let recordObjectManager: RecordObjectManager
	
	// MARK: - Na implementação de mais modelos, será necessário fazer um array de "current{model}", atualizar a func `updateArrays` e o enum `QueryType`
	// MARK: Além de atualizar a função `makeObjectsFromRecords` do recordObjectManager para lidar com outros tipos de objeto.
	@Published var currentFiles: [Recordable] = []
	@Published var currentFolders: [Recordable] = []
	@Published var currentClients: [Recordable] = []
	
	@Published var loading = false
	
	init() {
		self.container = CKContainer(identifier: "iCloud.com.TFS.LawSuit.CKContainer")
		self.publicDatabase = container.publicCloudDatabase
		
		self.cloudManager = CloudManager(container: container)
		self.recordObjectManager = RecordObjectManager()
	}
	
	public func getObjectsWith(query: QueryType) async -> [Recordable] {
		self.loading = true
		
		if let records = await cloudManager.fetchWithQuery(query.query) {
			if let objects = await recordObjectManager.makeObjectsFromRecords(records: records) {
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
	
}



