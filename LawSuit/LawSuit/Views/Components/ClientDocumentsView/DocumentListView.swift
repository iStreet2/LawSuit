//
//  DocumentListView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 11/09/24.
//
//visualização dos documentos em lista

import Foundation
import SwiftUI

struct DocumentListView: View {
    
    //MARK: ViewModels
    var openFolder: Folder
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var folders: FetchedResults<Folder>
    @FetchRequest(sortDescriptors: []) var filesPDF: FetchedResults<FilePDF>
    
    //MARK: Calculo da grid
    let spacing: CGFloat = 10
    let itemWidth: CGFloat = 90
    
    //MARK: Variáveis
    //    @State var showingGridView = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading){
                HStack {
                    Text("Nome e Número")
                        .frame(width: geometry.size.width * 0.60, alignment: .leading)
                    
                    Text("Tamanho")
                        .frame(width: geometry.size.width * 0.1, alignment: .leading)
                    
                    Text("Tipo")
                        .frame(width: geometry.size.width * 0.1, alignment: .leading)
                    
                    Text("Data de criação")
                        .frame(width: geometry.size.width * 0.15, alignment: .leading)
                }
                .frame(minWidth: 777)
                .frame(height: 13)
                .font(.footnote)
                .bold()
                .foregroundStyle(Color(.gray))
                
                Divider()
                
                HStack{
                    Button {
                        folderViewModel.closeFolder()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(folderViewModel.getPath().count() == 1)
                    .buttonStyle(PlainButtonStyle())
                    .font(.title2)
                    .padding(.bottom)
                }
                
                ScrollView {
                    VStack(alignment: .leading) {
                        FolderView(parentFolder: openFolder, geometry: geometry)
                            .onTapGesture(count: 2) {
                                folderViewModel.openFolder(folder: openFolder)
                            }
                        FilePDFGridView(parentFolder: openFolder, geometry: geometry)
                        
                    }
                    // .background(IndexPath % 2 == 0 ? Color.gray.opacity(0.1) : Color.white)
                    if openFolder.folders!.count == 0 && openFolder.files!.count == 0{
                        Text("Sem pastas ou arquivos")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .onChange(of: openFolder) { _ in
                dragAndDropViewModel.updateFramesFolder(folders: folders)
                dragAndDropViewModel.updateFramesFilePDF(filesPDF: filesPDF)
            }
            .contextMenu {
                Button {
                    //MARK: CoreData - Criar
                    var folder = dataViewModel.coreDataManager.folderManager.createAndReturnFolder(parentFolder: openFolder, name: "Nova Pasta")
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
                    folderViewModel.importAndReturnPDF(parentFolder: openFolder, dataViewModel: dataViewModel) { filePDF in
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
                            
                            try await dataViewModel.cloudManager.recordManager.addReference(from: openFolder, to: mutableFilePDF, referenceKey: "files")
                        }
                    }
                } label: {
                    Text("Importar PDF")
                    Image(systemName: "doc")
                }
            }
        }
    }
}

