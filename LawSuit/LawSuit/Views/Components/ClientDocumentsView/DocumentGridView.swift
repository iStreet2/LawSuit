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
                        dataViewModel.coreDataManager.folderManager.createFolder(parentFolder: openFolder, name: "Nova Pasta")
                        dragAndDropViewModel.updateFramesFolder(folders: folders)
                        dragAndDropViewModel.updateFramesFilePDF(filesPDF: filesPDF)
                    }, label: {
                        Text("Nova Pasta")
                        Image(systemName: "folder")
                    })
                    Button {
                        folderViewModel.importPDF(parentFolder: openFolder, dataViewModel: dataViewModel)
                        dragAndDropViewModel.updateFramesFolder(folders: folders)
                        dragAndDropViewModel.updateFramesFilePDF(filesPDF: filesPDF)
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
        .frame(maxHeight: .infinity)
    }
}
