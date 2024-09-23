//
//  CoreDataViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 12/08/24.
//

import Foundation
import CoreData


class CoreDataManager: ObservableObject {
    
    @Published var objects: [Any] = []
    
    var context: NSManagedObjectContext
    var folderManager: FolderManager
    var filePDFManager: FilePDFManager
    var lawyerManager: LawyerManager
    var lawsuitManager: LawsuitManager
    var clientManager: ClientManager
    var updateManager: UpdateManager
    var lawsuitNetworkingViewModel: LawsuitNetworkingViewModel
    var entityManager: EntityManager
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.context.automaticallyMergesChangesFromParent = true
        self.folderManager = FolderManager(context: context)
        self.filePDFManager = FilePDFManager(context: context)
        self.lawyerManager = LawyerManager(context: context)
        self.lawsuitManager = LawsuitManager(context: context)
        self.clientManager = ClientManager(context: context)
        self.updateManager = UpdateManager(context: context)
        self.lawsuitNetworkingViewModel = LawsuitNetworkingViewModel(lawsuitService: LawsuitNetworkingService(updateManager: self.updateManager), lawsuitManager: self.lawsuitManager)
        self.entityManager = EntityManager(context: context)
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
