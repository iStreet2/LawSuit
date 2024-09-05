//
//  DataViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 04/09/24.
//

import Foundation
import CoreData
import CloudKit

class DataViewModel: ObservableObject {
    
    //Aqui instancio apenas uma vez o container do CoreData e do CloudKit
    
    let coreDataContainer = NSPersistentContainer(name: "Model")
    let context: NSManagedObjectContext
    let cloudContainer: CKContainer = CKContainer(identifier: "iCloud.com.TFS.LawSuit.CKContainer")
    
    var coreDataManager: CoreDataManager
    var cloudManager: CloudManager
    var cloudDataConverter: CloudDataConverter
    
    init() {
        self.coreDataContainer.loadPersistentStores { descricao, error in
            if let error = error {
                print("There was an error loading the data from the model: \(error)")
            }
        }
        self.context = coreDataContainer.viewContext
        self.coreDataManager = CoreDataManager(context: context)
        self.cloudDataConverter = CloudDataConverter(context: context, container: cloudContainer)
        self.cloudManager = CloudManager(container: cloudContainer, cloudDataConverter: cloudDataConverter)
    }
    
}
