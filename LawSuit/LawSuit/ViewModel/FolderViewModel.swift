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
    
    @Published private var openFolder: Folder? //fala qual pasta ta aberta, n consegue acessar diretamente usa getOpenFolder, a q vc ta vendo agora
    @Published private var path = FolderStack() //path.itens acessa array d folders
    @Published var showingGridView = true
    
    func getFolderPath() -> String {
//        ForEach(getPath().getItens()) { item in
//            HStack {
//                Text(item.name ?? "sem item")
//                Image(systemName: "chevron.right")
//            }
//        }

        let folderNames = path.getItens().dropFirst().map { $0.name ?? "Sem nome"}
        return folderNames.joined(separator: " / ")
    }
    
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
    
    func resetFolderStack() { //path fica vazio []
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
    
    func importAndReturnPDF(parentFolder: Folder, dataViewModel: DataViewModel, completion: @escaping (FilePDF?) -> Void) {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [UTType.pdf]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                do {
                    let data = try Data(contentsOf: url)
                    let name = url.lastPathComponent
                    
                    // Salvo no CoreData o PDF aberto!
                    let filePDF = dataViewModel.coreDataManager.filePDFManager.createAndReturnFilePDF(parentFolder: parentFolder, name: name, content: data)
                    
                    // Chamamos o completion com o FilePDF criado
                    completion(filePDF)
                } catch {
                    print("Failed to load data from URL: \(error.localizedDescription)")
                    completion(nil) // Em caso de erro, retornamos nil
                }
            } else {
                completion(nil) // Se o usuário cancelar, também retornamos nil
            }
        }
    }
    
}
