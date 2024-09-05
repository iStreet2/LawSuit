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
    
    @Published private var openFolder: Folder?
    @Published private var path = FolderStack()
    
    func getOpenFolder() -> Folder? {
        if let openFolder = openFolder {
            return openFolder
        }
        return nil
    }
    
    func getPath() -> FolderStack {
        return path
    }
    
    func openFolder(folder: Folder?) {
        if let folder = folder {
            withAnimation(.easeIn(duration: 0.1)) {
                self.path.push(folder)
                self.openFolder = folder
            }
        }
    }
    
    func closeFolder() {
        withAnimation(.easeIn(duration: 0.1)) {
            let lastFolder = path.pop()
            //print(lastFolder.name ?? "Sem nome")
            self.openFolder = path.top()
        }
    }
    
    func resetFolderStack() {
        withAnimation(.easeIn(duration: 0.1)) {
            path.reset()
        }
    }
    
    func importPhoto(completion: @escaping (Data?) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [UTType.image]
        openPanel.allowsMultipleSelection = false
        
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                do {
                    let data = try Data(contentsOf: url)
                    completion(data)
                } catch {
                    print("Erro ao carregar os dados da imagem: \(error)")
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
   
    func importPDF(parentFolder: Folder, dataViewModel: DataViewModel) {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [UTType.pdf]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                do {
                    let data = try Data(contentsOf: url)
                    let name = url.lastPathComponent
                    //print(url)
                    
                    // Salvo no CoreData o PDF aberto!
                    dataViewModel.coreDataManager.filePDFManager.createFilePDF(parentFolder: parentFolder, name: name, content: data)
                } catch {
                    print("Failed to load data from URL: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
