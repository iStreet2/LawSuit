//
//  DocumentListView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 11/09/24.
//

import Foundation
import SwiftUI

struct DocumentListView: View {
    
    //MARK: ViewModels
    var folder: Folder
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
    
    var body: some View {
        //        if let openFolder = folderViewModel.getOpenFolder() {
        GeometryReader { geometry in
            ScrollView {
                HStack {
                    Button {
                        folderViewModel.closeFolder()
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(folderViewModel.getPath().count() == 1)
                    .buttonStyle(PlainButtonStyle())
                    .font(.title2)
                    .padding(.bottom)
                    Spacer()
                    Menu(content: {
                        Button {
                            dataViewModel.coreDataManager.folderManager.createFolder(parentFolder: folder, name: "Nova Pasta")
                        } label: {
                            Text("Nova Pasta")
                            Image(systemName: "folder")
                        }
                        Button {
                            folderViewModel.importPDF(parentFolder: folder, dataViewModel: dataViewModel)
                        } label: {
                            Text("Importar PDF")
                            Image(systemName: "doc")
                        }
                    }, label: {
                        Image(systemName: "plus")
                    })
                    .buttonStyle(PlainButtonStyle())
                    .font(.title2)
                    .padding(.bottom)
                }
                VStack {
                    ForEach(folders, id: \.self) { folder in
                        FolderIconListView(folder: folder, parentFolder: folder)
                            .onTapGesture(count: 2) {
                                folderViewModel.openFolder(folder: folder)
                            }
//                        FolderGridView(parentFolder: folder, geometry: geometry)
//                        FilePDFGridView(parentFolder: folder, geometry: geometry)

                    }
                    if folder.folders!.count == 0 && folder.files!.count == 0{
                        Text("Sem pastas ou arquivos")
                            .foregroundStyle(.gray)
                    }
                }
            }
            .onChange(of: folder) { _ in
                dragAndDropViewModel.updateFramesFolder(folders: folders)
                dragAndDropViewModel.updateFramesFilePDF(filesPDF: filesPDF)
            }
            .contextMenu {
                Button(action: {
                    dataViewModel.coreDataManager.folderManager.createFolder(parentFolder: folder, name: "Nova Pasta")
                }, label: {
                    Text("Nova Pasta")
                    Image(systemName: "folder")
                })
                Button {
                    folderViewModel.importPDF(parentFolder: folder, dataViewModel: dataViewModel)
                } label: {
                    Text("Importar PDF")
                    Image(systemName: "doc")
                }
            }
            //            .onDrop(of: ["public.folder", "public.file-url"], isTargeted: nil) { providers in
            //                dragAndDropViewModel.handleDrop(providers: providers, parentFolder: parentFolder, context: context, coreDataViewModel: coreDataViewModel)
            //                return true
            //            }
        }        }
}

