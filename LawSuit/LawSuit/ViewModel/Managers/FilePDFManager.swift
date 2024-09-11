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
    
    func createAndReturnFilePDF(parentFolder: Folder, name: String, content: Data) -> FilePDF {
        let newFilePDF = FilePDF(context: context)
        newFilePDF.id = UUID().uuidString
        newFilePDF.name = name
        newFilePDF.content = content
        newFilePDF.parentFolder = parentFolder
        parentFolder.addToFiles(newFilePDF)
        saveContext()
        return newFilePDF
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
