//
//  FileManager.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 12/08/24.
//

import SwiftUI
import CoreData

class FolderManager {
    
    var context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func createFolder(parentFolder: Folder, name: String) {
        withAnimation(.bouncy) {
            let newFolder = Folder(context: context)
            newFolder.id = UUID().uuidString
            newFolder.name = name
            newFolder.isEditing = true
            newFolder.createdAt = Date.now
            newFolder.parentFolder = parentFolder
            parentFolder.addToFolders(newFolder)
            saveContext()
        }
    }
	
	func getFolderItemsCount(folder: Folder) -> (Int, Int) {
		var files = 0
		var folders = 1
		
		if let subFiles = folder.files as? Set<FilePDF> {
			files = subFiles.count
		}
		
		if let subFolders = folder.folders as? Set<Folder> {
			for subFolder in subFolders {
				let result = getFolderItemsCount(folder: subFolder)
				folders += result.0
				files += result.1
			}
		}
		
		return (folders, files)
	}
    
    func deleteFolder(parentFolder: Folder, folder: Folder) {
        withAnimation(.bouncy) {
            // Deletar arquivos na pasta
            if let files = folder.files as? Set<FilePDF> {
                for file in files {
                    folder.removeFromFiles(file)
                    context.delete(file) // Deletar arquivo do contexto
                }
            }
            
            // Deletar subpastas recursivamente
            if let subFolders = folder.folders as? Set<Folder> {
                for subFolder in subFolders {
                    deleteFolder(parentFolder: folder, folder: subFolder) // Chama recursivamente para subpastas
                }
            }
            
            // Remover a pasta atual do parent e deletar
            parentFolder.removeFromFolders(folder)
            
            // Deletar a pasta do contexto
            context.delete(folder)
            
            // Salvar o contexto
            saveContext()
        }
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
    
    // Função para ativar edição
    func startEditing(folder: Folder) {
        folder.isEditing = true
        saveContext()
    }
    
    // Função para parar edição
    func stopEditing(folder: Folder) {
        folder.isEditing = false
        saveContext()
    }
    
    func removeSelectedFromAllFolders(folders: FetchedResults<Folder>) {
        for folder in folders {
            folder.isSelected = false
        }
    }
    
    func saveNameChanges(folder: Folder) {
        self.editFolderName(folder: folder, name: folder.name)
        folder.isEditing = false
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Error while saving the context on folder \(error)")
        }
    }
}
