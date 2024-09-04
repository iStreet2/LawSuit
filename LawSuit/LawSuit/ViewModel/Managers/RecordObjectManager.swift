//
//  RecordObjectManager.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 26/08/24.
//

import Foundation
import CloudKit
import CoreData
import PDFKit

class RecordObjectManager {
//	let container = CKContainer(identifier: "iCloud.com.TFS.LawSuit")
//	let publicDatabase: CKDatabase
//	
//	let coreDataContainer = NSPersistentContainer(name: "Model")
//	var coreDataContext: NSManagedObjectContext
//	
//	init() {
//		self.coreDataContainer.loadPersistentStores { descricao, error in
//			if let error = error {
//				print("There was an error loading the data from the model: \(error)")
//			}
//		}
//		self.coreDataContext = self.coreDataContainer.viewContext
//		self.coreDataContext.automaticallyMergesChangesFromParent = true
//		
//		self.publicDatabase = container.publicCloudDatabase
//	}
//	
//	
//	func makeObjectsFromRecords(records: [CKRecord]) async -> [Recordable]? {
//		
//		var objects: [Recordable] = []
//		
//		for record in records {
//			switch record.recordType {
//			case "FilePDF":
//				let fileObject = FilePDF(context: coreDataContext)
//				
//				if let name = record["name"] as? String {
//					fileObject.name = name
//				}
//				if let id = record["id"] as? String {
//					fileObject.id = id
//				}
//				if let asset = record["content"] as? CKAsset {
//					guard let bin = asset.fileURL else { return nil }
//					do {
//						let pdfData = try Data(contentsOf: bin)
//						
//						fileObject.content = pdfData
//					} catch {
//						print("Could not get pdf Data as BIN: \(error)")
//					}
//				}
//				if let recordName = record.recordID.recordName as? String {
//					fileObject.recordName = recordName
//				}
//				
//				objects.append(fileObject)
//			
//			case "Folder":
//				let folderObject = Folder(context: coreDataContext)
//				
//				if let name = record["name"] as? String {
//					folderObject.name = name
//				}
//				if let id = record["id"] as? String {
//					folderObject.id = id
//				}
//				let recordName = record.recordID.recordName
//				folderObject.recordName = recordName
//				
//				if let folderReferences = record["folders"] as? [CKRecord.Reference] {
//					for reference in folderReferences {
//						do {
//							let relatedRecord = try await publicDatabase.record(for: reference.recordID)
//							if let relatedObject = await makeObjectsFromRecords(records: [relatedRecord]) as? [Folder] {
//								folderObject.addToFolders(relatedObject.first!)
//							}
//						} catch {
//							print("Error in relating folderRecord to reference: \(error)")
//						}
//					}
//				}
//				if let fileReferences = record["files"] as? [CKRecord.Reference] {
//					for reference in fileReferences {
//						do {
//							let relatedRecord = try await publicDatabase.record(for: reference.recordID)
//							if let relatedObject = await makeObjectsFromRecords(records: [relatedRecord]) as? [FilePDF] {
//								folderObject.addToFiles(relatedObject.first!)
//							}
//						} catch {
//							print("Error in relating objectRecord to reference: \(error)")
//						}
//					}
//				}
//				
//				objects.append(folderObject)
//			
//			case "Client":
//				let clientObject = Client(context: coreDataContext)
//				
//				let recordName = record.recordID.recordName
//				clientObject.recordName = recordName
//				
//				objects.append(clientObject)
//			default:
//				return nil
//			}
//		}
//		
//		return objects
//	}
}
