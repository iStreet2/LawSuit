//
//  DocumentActionButtonsView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 16/09/24.
//
import Foundation
import SwiftUI

struct DocumentActionButtonsView: View {
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    
    //MARK: Viariáveis
//    @Binding var showingGridView: Bool
    var folder: Folder
    
    var body: some View {
        HStack{
            Button {
                folderViewModel.showingGridView = true
            } label: {
                Image(systemName: "square.grid.2x2")
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.gray)
                            .opacity(folderViewModel.showingGridView ? 0.4 : 0.0)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button(action: {
                folderViewModel.showingGridView = false
            }, label: {
                Image(systemName: "list.bullet")
                    .padding(4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Color.gray)
                            .opacity(folderViewModel.showingGridView ? 0.0 : 0.4) 

                    )
            })
            .buttonStyle(PlainButtonStyle())
            .foregroundStyle(.gray)
            
            
            Menu(content: {
                Button {
                    //MARK: CoreData - Criar
                    var folder = dataViewModel.coreDataManager.folderManager.createAndReturnFolder(parentFolder: folder, name: "Nova Pasta")
                    //MARK: CloudKit - Criar
                    Task {
                        do {
                            try await dataViewModel.cloudManager.recordManager.saveObject(object: &folder, relationshipsToSave: ["folders", "files"])
                            try await dataViewModel.cloudManager.recordManager.addReference(from: folder, to: folder.parentFolder!, referenceKey: "folders")
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Nova Pasta")
                    Image(systemName: "folder")
                }
                Button {
                    //MARK: CoreData - Criar
                    folderViewModel.importAndReturnPDF(parentFolder: folder, dataViewModel: dataViewModel) { filePDF in
                        guard var mutableFilePDF = filePDF else {
                            print("Falha ao importar o PDF.")
                            return
                        }
                        //MARK: CloudKit - Criar
                        Task {
                            do {
                                try await dataViewModel.cloudManager.recordManager.saveObject(object: &mutableFilePDF, relationshipsToSave: [])
                            } catch {
                                print(error.localizedDescription)
                            }
                            
                            try await dataViewModel.cloudManager.recordManager.addReference(from: folder, to: mutableFilePDF, referenceKey: "files")
                        }
                    }
                } label: {
                    Text("Importar PDF")
                    Image(systemName: "doc")
                }
            }, label: {
                Image(systemName: "plus")
                    .foregroundStyle(Color(.gray))
            })
            .buttonStyle(PlainButtonStyle())
        }
        .font(.title2)
        .foregroundStyle(Color(.gray))
        .padding(.trailing)
        
    }
}


