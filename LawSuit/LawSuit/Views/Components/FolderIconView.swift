//
//  FolderIconView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import SwiftUI

struct FolderIconView: View {
    
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    @ObservedObject var folder: Folder
    @ObservedObject var parentFolder: Folder
    @State var isEditing = false
    @State var folderName: String
    
    init(folder: Folder, parentFolder: Folder) {
        self.folder = folder
        self.parentFolder = parentFolder
        folderName = folder.name!
    }
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        VStack {
            Image("folder")
            
            if isEditing {
                TextField("", text: $folderName, onEditingChanged: { _ in
                    
                }, onCommit: {
                    saveChanges()
                })
                .onExitCommand(perform: cancelChanges)
                .lineLimit(1)
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
                // Ação para excluir a pasta
                withAnimation(.easeIn) {
                    coreDataViewModel.folderManager.deleteFolder(parentFolder: parentFolder, folder: folder)
                }
            }) {
                Text("Excluir")
                Image(systemName: "trash")
            }
        }
        
    }
    private func cancelChanges() {
        folderName = folder.name!
        isEditing = false
    }
    
    private func saveChanges() {
        coreDataViewModel.folderManager.editFolderName(folder: folder, name: folderName)
        isEditing = false
    }
}

