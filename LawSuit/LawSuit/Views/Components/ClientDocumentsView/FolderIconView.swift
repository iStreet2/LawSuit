//
//  FolderIconView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import SwiftUI

struct FolderIconView: View {
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    //MARK: Variáveis de estado
    @ObservedObject var folder: Folder
    @ObservedObject var parentFolder: Folder
    @State var isEditing = false
    @State var folderName: String
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    init(folder: Folder, parentFolder: Folder) {
        self.folder = folder
        self.parentFolder = parentFolder
        folderName = folder.name!
    }
    
    var body: some View {
        VStack {
            Image("folder")
            
            if isEditing {
                TextField("", text: $folderName, onEditingChanged: { _ in
                }, onCommit: {
                    saveChanges()
                })
                .onExitCommand(perform: cancelChanges)
                .lineLimit(2)
                .frame(height: 12)
            }
            else {
                Text(folder.name ?? "Sem nome")
                    .lineLimit(1)
                    .onTapGesture(count: 2) {
                        isEditing = true
                    }
            }
        }
        .onDisappear {
            isEditing = false
        }
        .onAppear {
            if folderName == "Nova Pasta" {
                isEditing = true
            }
        }
        .contextMenu {
            Button(action: {
                folderViewModel.openFolder(folder: folder)
            }) {
                Text("Abrir Pasta")
                Image(systemName: "folder")
            }
            Button(action: {
                isEditing = true
            }) {
                Text("Renomear")
                Image(systemName: "pencil")
            }
            Button(action: {
                Task {
                    //MARK: CloudKit
                    do {
                        try await dataViewModel.cloudManager.recordManager.removeReference(from: parentFolder, to: folder, referenceKey: "folders")
                        try await dataViewModel.cloudManager.recordManager.deleteFolderRecursivelyInCloudKit(folder: folder)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    //MARK: CoreData
                    withAnimation(.easeIn) {
                        dataViewModel.coreDataManager.folderManager.deleteFolder(parentFolder: parentFolder, folder: folder)
                    }
                }
            }) {
                Text("Excluir")
                Image(systemName: "trash")
            }
        }
//        .onDrag {
//            // Gera uma URL temporária para a pasta
//            let tempDirectory = FileManager.default.temporaryDirectory
//            let tempFolderURL = tempDirectory.appendingPathComponent(folder.name!)
//            
//            // Cria a pasta temporária
//            try? FileManager.default.createDirectory(at: tempFolderURL, withIntermediateDirectories: true, attributes: nil)
//            
//            // Retorna o NSItemProvider com a URL da pasta temporária
//            return NSItemProvider(object: tempFolderURL as NSURL)
//        }
        
    }
    private func cancelChanges() {
        folderName = folder.name!
        isEditing = false
    }
    
    private func saveChanges() {
        //MARK: CoreData
        dataViewModel.coreDataManager.folderManager.editFolderName(folder: folder, name: folderName)
        
        //MARK: CloudKit
        let propertyNames = ["name"]
        let propertyValues: [Any] = [folderName]
        Task {
            try await dataViewModel.cloudManager.recordManager.updateObjectInCloudKit(object: folder, propertyNames: propertyNames, propertyValues: propertyValues)
        }
        
        isEditing = false
    }
}

