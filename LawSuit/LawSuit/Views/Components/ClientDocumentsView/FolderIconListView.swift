////
////  FolderIconListView.swift
////  LawSuit
////
////  Created by Emily Morimoto on 12/09/24.
////
////icone das pastas em lista
//
//import Foundation
//import SwiftUI

//PASTA PARA DELETAR PORÉM NÃO SEI SE POSSO DELETAR

//struct FolderIconListView: View{
//    //MARK: ViewModels
//    @EnvironmentObject var folderViewModel: FolderViewModel
//    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
//    
//    //MARK: Variáveis de estado
//    @ObservedObject var folder: Folder
//    @ObservedObject var parentFolder: Folder
//    @State var isEditing = false
//    @State var folderName: String
//    
//    //MARK: CoreData
//    @EnvironmentObject var dataViewModel: DataViewModel
//    @Environment(\.managedObjectContext) var context
//    
//    init(folder: Folder, parentFolder: Folder) {
//        self.folder = folder
//        self.parentFolder = parentFolder
//        folderName = folder.name!
//    }
//    
//    var body: some View {
//        HStack {
//            Image("folder")
//                .resizable()
//                .frame(width: 18,height: 14)
//            
//            if isEditing {
//                TextField("", text: $folderName, onEditingChanged: { _ in
//                }, onCommit: {
//                    saveChanges()
//                })
//                .onExitCommand(perform: cancelChanges)
//                .lineLimit(2)
//                .frame(height: 12)
//            }
//            else {
//                Text(folder.name ?? "Sem nome")
//                    .lineLimit(1)
//                    .onTapGesture(count: 2) {
//                        isEditing = true
//                    }
//            }
//            
//            
//        }
//        .border(.red)
//        .onDisappear {
//            isEditing = false
//        }
//        .onAppear {
//            if folderName == "Nova Pasta" {
//                isEditing = true
//            }
//        }
//        .contextMenu {
//            Button(action: {
//                folderViewModel.openFolder(folder: folder)
//            }) {
//                Text("Abrir Pasta")
//                Image(systemName: "folder")
//            }
//            Button(action: {
//                isEditing = true
//            }) {
//                Text("Renomear")
//                Image(systemName: "pencil")
//            }
//            Button(action: {
//                // Ação para excluir a pasta
//                withAnimation(.easeIn) {
//                    dataViewModel.coreDataManager.folderManager.deleteFolder(parentFolder: parentFolder, folder: folder)
//                }
//            }) {
//                Text("Excluir")
//                Image(systemName: "trash")
//            }
//        }
//        //        .onDrag {
//        //            // Gera uma URL temporária para a pasta
//        //            let tempDirectory = FileManager.default.temporaryDirectory
//        //            let tempFolderURL = tempDirectory.appendingPathComponent(folder.name!)
//        //
//        //            // Cria a pasta temporária
//        //            try? FileManager.default.createDirectory(at: tempFolderURL, withIntermediateDirectories: true, attributes: nil)
//        //
//        //            // Retorna o NSItemProvider com a URL da pasta temporária
//        //            return NSItemProvider(object: tempFolderURL as NSURL)
//        //        }
//        
//    }
//    private func cancelChanges() {
//        folderName = folder.name!
//        isEditing = false
//    }
//    
//    private func saveChanges() {
//        dataViewModel.coreDataManager.folderManager.editFolderName(folder: folder, name: folderName)
//        isEditing = false
//    }
//}
//
