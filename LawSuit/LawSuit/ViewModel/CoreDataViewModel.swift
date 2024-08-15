//
//  CoreDataViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 12/08/24.
//

import Foundation
import CoreData


class CoreDataViewModel: ObservableObject {
    
    var container = NSPersistentContainer(name: "Model")
    var context: NSManagedObjectContext
    var folderManager: FolderManager
    var filePDFManager: FilePDFManager
    var lawyerManager: LawyerManager
    var processManager: ProcessManager
    var clientManager: ClientManager

    init() {
        
//        guard let storeURL = container.persistentStoreDescriptions.first?.url else { return }
//
//                do {
//                    try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
//                    try container.persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
//                    print("Persistent store reset successfully.")
//                } catch {
//                    print("Failed to reset persistent store: \(error)")
//                }
        
        
        container.persistentStoreDescriptions.first?.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions.first?.shouldInferMappingModelAutomatically = true
        
        self.container.loadPersistentStores { descricao, error in
            if let error = error {
                print("There was an error loading the data from the model: \(error)")
            }
        }
        self.context = self.container.viewContext
        self.folderManager = FolderManager(context: context)
        self.filePDFManager = FilePDFManager(context: context)
        self.lawyerManager = LawyerManager(context: context)
        self.processManager = ProcessManager(context: context)
        self.clientManager = ClientManager(context: context)
    }
}
