//
//  FileManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 12/08/24.
//

import Foundation
import CoreData

class FilePDFManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createFilePDF(parentFolder: Folder, name: String, content: Data) {
        let newFilePDF = FilePDF(context: context)
        newFilePDF.id = UUID().uuidString
        newFilePDF.name = name
        newFilePDF.content = content
        newFilePDF.isEditing = false
        newFilePDF.createdAt = Date.now
        newFilePDF.parentFolder = parentFolder
        parentFolder.addToFiles(newFilePDF)
        saveContext()
    }
    
    func deleteFilePDF(parentFolder: Folder, filePDF: FilePDF) {
        parentFolder.removeFromFiles(filePDF)
        context.delete(filePDF)
        saveContext()
    }
    
    func editFilePDFName(filePDF: FilePDF, name: String) {
        filePDF.name = name
        saveContext()
    }
    
    func moveFilePDF(parentFolder: Folder, movingFilePDF: FilePDF, destinationFolder: Folder) {
        parentFolder.removeFromFiles(movingFilePDF)
        movingFilePDF.parentFolder = destinationFolder
        destinationFolder.addToFiles(movingFilePDF)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving context on file")
        }
        
    }
    
}
