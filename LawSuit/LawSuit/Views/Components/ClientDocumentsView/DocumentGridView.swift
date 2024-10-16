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
    @FetchRequest var folders: FetchedResults<Folder>
    @FetchRequest var files: FetchedResults<FilePDF>
    
    //MARK: Calculo da grid
    let spacing: CGFloat = 10
    let itemWidth: CGFloat = 90
    
    //MARK: Viariáveis
    var openFolder: Folder
    
    init(openFolder: Folder) {
        self.openFolder = openFolder
        _folders = FetchRequest<Folder>(
            sortDescriptors: []
            ,predicate: NSPredicate(format: "parentFolder == %@", openFolder)
        )
        _files = FetchRequest<FilePDF>(
            sortDescriptors: []
            ,predicate: NSPredicate(format: "parentFolder == %@", openFolder)
        )
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                let columns = Int(geometry.size.width / (itemWidth + spacing))
                let gridItems = Array(repeating: GridItem(.flexible(), spacing: spacing), count: max(columns, 1))
                ScrollView {
                    VStack(spacing: 0) {
                        LazyVGrid(columns: gridItems, spacing: spacing) {
                            FolderView(parentFolder: openFolder)
                            FilePDFView(parentFolder: openFolder)
                        }
                        if folders.count == 0 && files.count == 0{
                            Text("Sem pastas ou arquivos")
                                .foregroundStyle(.gray)
                                .frame(height: geometry.size.height / 2)
                        }
                    }
                    .padding(.top, 20)
                }
                .contextMenu {
                    Button(action: {
                        dataViewModel.coreDataManager.folderManager.createFolder(parentFolder: openFolder, name: "Nova Pasta")
                    }, label: {
                        Text("Nova Pasta")
                        Image(systemName: "folder")
                    })
                    Button {
                        folderViewModel.importPDF(parentFolder: openFolder, dataViewModel: dataViewModel)
                    } label: {
                        Text("Importar PDF")
                        Image(systemName: "doc")
                    }
                }
                .onDrop(of: ["public.folder", "public.file-url"], isTargeted: nil) { providers in
                    withAnimation {
                        // Verifica se a pasta sendo arrastada é uma pasta interna
                        if let movingFolder = dragAndDropViewModel.movingFolder,
                           movingFolder.parentFolder == openFolder {
                            dragAndDropViewModel.movingFolder = nil
                            return false
                        }
                        // Se não for uma pasta interna, executa a lógica de drop normalmente
                        dragAndDropViewModel.handleDrop(providers: providers, parentFolder: openFolder, destinationFolder: openFolder, context: context, dataViewModel: dataViewModel)
                        return true
                    }
                }
            }
            .padding(.horizontal, 20)
            .frame(maxHeight: .infinity)
            .background(.black.opacity(0.01))
        }
        .frame(maxHeight: .infinity)
    }
}
