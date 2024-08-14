//
//  FolderExamples.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import Foundation

struct FolderExamples {
    
    static func folderExample() -> Folder {
        
        let context = CoreDataViewModel().context
        
        var insideFolders: [Folder] = []

        let folder = Folder(context: context)
        folder.name = ""
        folder.id = ""
        
        for i in 0...3 {
            let folderInside = Folder(context: context)
            folderInside.name = "pasta\(i)"
            folderInside.id = UUID().uuidString
            folderInside.parentFolder = folder
            insideFolders.append(folder)
            folder.addToFolders(folderInside)
        }

        
        print(folder.folders)
        
        return folder
    }
    
    static func foldersExample() -> [Folder] {
        var folders: [Folder] = []
        for i in 0..<3 {
            let folder = Folder(context: CoreDataViewModel().context)
            folder.name = "folder\(i+1)"
            folder.id = UUID().uuidString
            folders.append(folder)
        }
        return folders
    }
    
}
