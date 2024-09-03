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
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var folders: FetchedResults<Folder>
    @FetchRequest(sortDescriptors: []) var filesPDF: FetchedResults<FilePDF>
    
    //MARK: Calculo da grid
    let spacing: CGFloat = 10
    let itemWidth: CGFloat = 90
    
    var body: some View {
        if let openFolder = folderViewModel.getOpenFolder() {
            GeometryReader { geometry in
                let columns = Int(geometry.size.width / (itemWidth + spacing))
                let gridItems = Array(repeating: GridItem(.flexible(), spacing: spacing), count: max(columns, 1))
                ScrollView {
                    HStack {
                        Group {
                            Button {
                                folderViewModel.closeFolder()
                            } label: {
                                Image(systemName: "chevron.left")
                            }
                            .disabled(folderViewModel.getPath().count() == 1)
                            Spacer()
                            Button {
                                folderViewModel.importPDF(parentFolder: openFolder, coreDataViewModel: coreDataViewModel)
                            } label: {
                                Image(systemName: "doc")
                            }
                            
                            Button {
                                coreDataViewModel.folderManager.createFolder(parentFolder: openFolder, name: "Nova Pasta")
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .font(.title2)
                        .padding(.bottom)
                        Spacer()
                    }
                    VStack {
                        LazyVGrid(columns: gridItems, spacing: spacing) {
                            FolderGridView(parentFolder: openFolder, geometry: geometry)
                            FilePDFGridView(parentFolder: openFolder, geometry: geometry)
                        }
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
                    Button(action: {
                        coreDataViewModel.folderManager.createFolder(parentFolder: openFolder, name: "Nova Pasta")
                    }, label: {
                        Text("Nova Pasta")
                        Image(systemName: "folder")
                    })
                    Button {
                        folderViewModel.importPDF(parentFolder: openFolder, coreDataViewModel: coreDataViewModel)
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
        }
    }
}
