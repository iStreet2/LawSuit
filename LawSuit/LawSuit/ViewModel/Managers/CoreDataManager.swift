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
    var updateManager = UpdateManager()
    var lawsuitManager = LawsuitManager()
    var lawsuitNetworkingViewModel: LawsuitNetworkingViewModel
    
    init(context: NSManagedObjectContext) {
        self.context = context
        self.context.automaticallyMergesChangesFromParent = true
        self.lawsuitNetworkingViewModel = LawsuitNetworkingViewModel(updateManager: updateManager, lawsuitManager: lawsuitManager, lawsuitService: LawsuitNetworkingService(updateManager: self.updateManager))
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
    
    func getClientAndEntity(for lawsuit: Lawsuit) -> (client: Client?, entity: Entity?) {
           if lawsuit.authorID.hasPrefix("client:") {
               if let author = clientManager.fetchFromId(id: lawsuit.authorID),
                  let defendant = entityManager.fetchFromID(id: lawsuit.defendantID) {
                   return (client: author, entity: defendant)
               }
           } else {
               if let defendant = clientManager.fetchFromId(id: lawsuit.defendantID),
                  let author = entityManager.fetchFromID(id: lawsuit.authorID) {
                   return (client: defendant, entity: author)
               }
           }
           return (client: nil, entity: nil)
       }
}
