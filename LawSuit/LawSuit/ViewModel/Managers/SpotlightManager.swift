//
//  SpotlightManager.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/09/24.
//

import Foundation
import CoreData
import CoreSpotlight
import CoreServices

class SpotlightManager {
	
	var coreDataContainer: NSPersistentContainer
	var context: NSManagedObjectContext
	
	init(container: NSPersistentContainer, context: NSManagedObjectContext) {
		self.coreDataContainer = container
		self.context = context
	}
	
	func fetchCoreDataObjects<T: NSManagedObject>(for model: CoreDataModelsEnumerator) throws -> [T] {
		let fetchRequest = NSFetchRequest<T>(entityName: model.entityName)
		
		do {
			let results = try context.fetch(fetchRequest)
			return results
		} catch {
			print("Could not retrieve \(model.entityName): \(error)")
			throw error
		}
	}
	
	func getSpotlightList(for section: String) -> [any EntityWrapper] {
		do {
			let clients = try self.fetchCoreDataObjects(for: .client) as! [Client]
			let clientWrappers = clients.map { ClientWrapper(client: $0) }
			
			let lawsuits = try self.fetchCoreDataObjects(for: .lawsuit) as! [Lawsuit]
			let lawsuitWrappers = lawsuits.map { LawsuitWrapper(lawsuit: $0) }
			
			let files = try self.fetchCoreDataObjects(for: .file) as! [FilePDF]
			let fileWrappers = files.map { FileWrapper(file: $0) }
		
			switch section {
			case "Clientes":
				return clientWrappers
			case "Processos":
				return lawsuitWrappers
			case "Documentos":
				return fileWrappers
			default:
				return []
			}
		} catch {
			print("Failed to form spotlight list: \(error)")
		}
		
		return []
	}
	
	func getSpotlightListTitles(for searchString: String) -> [String] {
		do {
			if searchString.starts(with: try Regex("[a-z]")) {
				return ["Clientes", "Processos", "Documentos"]
			}
			else if searchString.starts(with: try Regex("[0-9]")) {
				return ["Processos", "Clientes", "Documentos"]
			}
			else {
				return ["Documentos", "Clientes", "Processos"]
			}
		} catch {
			print("Error getting spotlight list titles: \(error)")
		}
		return []
	}
	
	func indexObjectsToSpotlight(objects: [NSManagedObject], for modelType: CoreDataModelsEnumerator) {
		var searchableItems: [CSSearchableItem] = []
		
		for object in objects  {
			if modelType == .client, let client = object as? Client {
				let attributes = CSSearchableItemAttributeSet(contentType: .content)
				attributes.title = client.name
				attributes.contentDescription = client.cellphone
				
				let searchableItem = CSSearchableItem(
					uniqueIdentifier: client.objectID.uriRepresentation().absoluteString,
					domainIdentifier: modelType.entityName,
					attributeSet: attributes
				)
				searchableItems.append(searchableItem)
				
			}
			else if modelType == .file, let file = object as? FilePDF {
				let attributes = CSSearchableItemAttributeSet(contentType: .content)
				
				if let fileName = file.name {
					attributes.title = file.name
					
					let searchableItem = CSSearchableItem(
						uniqueIdentifier: file.objectID.uriRepresentation().absoluteString,
						domainIdentifier: modelType.entityName,
						attributeSet: attributes
					)
					searchableItems.append(searchableItem)
				} else {
					return
				}
				
			}
			else if modelType == .lawsuit, let lawsuit = object as? Lawsuit {
				let attributes = CSSearchableItemAttributeSet(contentType: .content)
				
				let searchableItem = CSSearchableItem(
					uniqueIdentifier: lawsuit.objectID.uriRepresentation().absoluteString,
					domainIdentifier: modelType.entityName,
					attributeSet: attributes)
				searchableItems.append(searchableItem)
			}
		}
		
		CSSearchableIndex.default().indexSearchableItems(searchableItems) { error in
			if let error = error {
				print("Failed to index items: \(error)\n\(error.localizedDescription)")
			} else {
				print("Succesfully indexed items")
			}
		}
	}
	 
	
	func removeIndexedObject(_ object: NSManagedObject) {
		let identifier = object.objectID.uriRepresentation().absoluteString
		
		CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: [identifier]) { error in
			if let error = error {
				print("Failed to delete indexed item: \(error)\n\(error.localizedDescription)")
			} else {
				print("Succesfully deleted indexed item")
			}
		}
	}
	
	func getObjectByURI(uri: String) -> Recordable? {
		if let url = URL(string: uri), let objectID = coreDataContainer.persistentStoreCoordinator.managedObjectID(forURIRepresentation: url) {
			return context.object(with: objectID) as? Recordable
		} else {
			print("Could not get object from URI")
		}
		return nil
	}
}
