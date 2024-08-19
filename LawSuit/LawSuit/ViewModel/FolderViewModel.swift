//
//  FolderViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


class FolderViewModel: ObservableObject {
    
    @Published public var openFolder: Folder?
    @Published public var path = FolderStack()
    
    func openFolder(folder: Folder) {
        withAnimation(.easeIn(duration: 0.1)) {
            self.path.push(folder)
            self.openFolder = folder
        }
    }
    
    func closeFolder() {
        withAnimation(.easeIn(duration: 0.1)) {
            let lastFolder = path.pop()
            print(lastFolder.name ?? "Sem nome")
            self.openFolder = path.top()
        }
    }
    
    func importPDF(parentFolder: Folder, coreDataViewModel: CoreDataViewModel) {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [UTType.pdf]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                do {
                    let data = try Data(contentsOf: url)
                    let name = url.lastPathComponent
                    print(url)
                    
                    // Salvo no CoreData o PDF aberto!
                    coreDataViewModel.filePDFManager.createFilePDF(parentFolder: parentFolder, name: name, content: data)
                } catch {
                    print("Failed to load data from URL: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
