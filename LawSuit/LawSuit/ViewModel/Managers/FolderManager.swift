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
    
    func createAndReturnFolder(parentFolder: Folder, name: String) -> Folder {
        let newFolder = Folder(context: context)
        newFolder.id = UUID().uuidString
        newFolder.name = name
        newFolder.parentFolder = parentFolder
        parentFolder.addToFolders(newFolder)
        saveContext()
        return newFolder
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
    
    func fetchAllFolders() -> [Folder] {
        let fetchRequest: NSFetchRequest<Folder> = Folder.fetchRequest()
        do {
            let folders = try context.fetch(fetchRequest)
            return folders
        } catch {
            print("Erro ao buscar pastas: \(error)")
            return []
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving the context on folder")
        }
    }
}
