//
//  DocumentGridView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import SwiftUI

struct DocumentGridView: View {
    
    //MARK: ViewModels
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
    
    //MARK: Viariáveis
    var openFolder: Folder
    
    var body: some View {
        //senao criaria um openFolder novo e não abriria o nosso
        //        if let openFolder = folderViewModel.getOpenFolder() {
        GeometryReader { geometry in
            
            VStack(alignment: .leading, spacing: 0) {
                
                let columns = Int(geometry.size.width / (itemWidth + spacing))
                let gridItems = Array(repeating: GridItem(.flexible(), spacing: spacing), count: max(columns, 1))
                ScrollView {
                    VStack(spacing: 0) {
                        LazyVGrid(columns: gridItems, spacing: spacing) {
                            FolderView(parentFolder: openFolder, geometry: geometry)
                            FilePDFGridView(parentFolder: openFolder, geometry: geometry)
                        }
                        if openFolder.folders!.count == 0 && openFolder.files!.count == 0{
                            Text("Sem pastas ou arquivos")
                                .foregroundStyle(.gray)
                                .frame(height: geometry.size.height / 2)
                        }
                    }
                    .padding(.trailing, 25)
                    .padding(.top, 20)
                }
                .onChange(of: openFolder) { _ in
                    dragAndDropViewModel.updateFramesFolder(folders: folders)
                    dragAndDropViewModel.updateFramesFilePDF(filesPDF: filesPDF)
                }
                .contextMenu {
                    Button(action: {
                        //MARK: CoreData - Criar
                        var folder = dataViewModel.coreDataManager.folderManager.createAndReturnFolder(parentFolder: openFolder, name: "Nova Pasta")
                        //MARK: CloudKit - Criar
                        Task {
                            do {
                                try await dataViewModel.cloudManager.recordManager.saveObject(object: &folder, relationshipsToSave: ["folders", "files"])
                                try await dataViewModel.cloudManager.recordManager.addReference(from: openFolder, to: folder, referenceKey: "folders")
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }, label: {
                        Text("Nova Pasta")
                        Image(systemName: "folder")
                    })
                    Button {
                        //MARK: Salvar no CoreData
                        folderViewModel.importAndReturnPDF(parentFolder: openFolder, dataViewModel: dataViewModel) { filePDF in
                            // Verifique se o PDF foi corretamente retornado
                            guard var mutableFilePDF = filePDF else {
                                print("Falha ao importar o PDF.")
                                return
                            }
                            
                            //MARK: CloudKit - Criar
                            Task {
                                do {
                                    // Agora mutableFilePDF é mutável e pode ser passado com `&`
                                    try await dataViewModel.cloudManager.recordManager.saveObject(object: &mutableFilePDF, relationshipsToSave: [])
                                } catch {
                                    print(error.localizedDescription)
                                }

                                // Adicionar referência ao arquivo PDF na pasta aberta
                                try await dataViewModel.cloudManager.recordManager.addReference(from: openFolder, to: mutableFilePDF, referenceKey: "files")
                            }
                        }
                    } label: {
                        Text("Importar PDF")
                        Image(systemName: "doc")
                    }
                }
                //            .onDrop(of: ["public.folder", "public.file-url"], isTargeted: nil) { providers in
                //                dragAndDropViewModel.handleDrop(providers: providers, parentFolder: parentFolder, context: context, coreDataViewModel: coreDataViewModel)
                //                return true
                //            }
                                
            }
            .frame(maxHeight: .infinity)
            .padding(.leading, 10)
            .background(.black.opacity(0.01))
        }
        //.border(Color(.quaternaryLabelColor))
        .frame(maxHeight: .infinity)
    }
}
