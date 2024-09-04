//
//  CoreDataViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 12/08/24.
//

import Foundation
import CoreData


class CoreDataViewModel: ObservableObject {
	
	@Published var objects: [Any] = []
	
	let container = NSPersistentContainer(name: "Model")
	var context: NSManagedObjectContext
	var folderManager: FolderManager
	var filePDFManager: FilePDFManager
	var lawyerManager: LawyerManager
	var lawsuitManager: LawsuitManager
	var clientManager: ClientManager
  var updateManager: UpdateManager
//	var recordObjectManager: RecordObjectManager
	
	init() {
		self.container.loadPersistentStores { descricao, error in
			if let error = error {
				print("There was an error loading the data from the model: \(error)")
			}
		}
		self.context = self.container.viewContext
		self.context.automaticallyMergesChangesFromParent = true
		self.folderManager = FolderManager(context: context)
		self.filePDFManager = FilePDFManager(context: context)
		self.lawyerManager = LawyerManager(context: context)
		self.lawsuitManager = LawsuitManager(context: context)
		self.clientManager = ClientManager(context: context)
    self.updateManager = UpdateManager(context: context)
//		self.recordObjectManager = RecordObjectManager(context: context)
	}
	
	func deleteAllData() {
		let entityNames = context.persistentStoreCoordinator?.managedObjectModel.entities.map({ $0.name ?? "" }) ?? []
		for entityName in entityNames {
			let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
			fetchRequest.includesPropertyValues = false
			do {
				let items = try context.fetch(fetchRequest) as! [NSManagedObject]
				for item in items {
					context.delete(item)
				}
			} catch {
				print("Error deleting \(entityName): \(error)")
			}
		}
		do {
			try context.save()
		} catch {
			print("Error saving context after deletion: \(error)")
		}
	}
}
