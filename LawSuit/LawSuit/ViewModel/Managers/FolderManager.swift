//
//  FileManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 12/08/24.
//

import Foundation
import CoreData

class FolderManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createFolder(parentFolder: Folder, name: String) {
        let newFolder = Folder(context: context)
        newFolder.id = UUID().uuidString
        newFolder.name = name
        newFolder.parentFolder = parentFolder
        parentFolder.addToFolders(newFolder)
        saveContext()
    }
    
    func deleteFolder(parentFolder: Folder, folder: Folder) {
        parentFolder.removeFromFolders(folder)
        context.delete(folder)
        saveContext()
    }
    
    func editFolderName(folder: Folder, name: String) {
        folder.name = name
        saveContext()
    }
    
    func moveFolder(parentFolder: Folder, movingFolder: Folder, destinationFolder: Folder) {
        parentFolder.removeFromFolders(movingFolder)
        movingFolder.parentFolder = destinationFolder
        destinationFolder.addToFolders(movingFolder)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error in saving the context")
        }
    }
}
