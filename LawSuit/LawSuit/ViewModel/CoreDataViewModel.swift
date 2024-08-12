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

    init() {
        self.container.loadPersistentStores { descricao, error in
            if let error = error {
                print("There was an error loading the data from the model: \(error)")
            }
        }
        self.context = self.container.viewContext
        self.folderManager = FolderManager(context: self.context)
        self.filePDFManager = FilePDFManager(context: self.context)
    }

    
}
