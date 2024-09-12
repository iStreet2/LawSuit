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
        if let openFolder = folderViewModel.getOpenFolder() {
            GeometryReader { geometry in
                let columns = Int(geometry.size.width / (itemWidth + spacing))
                let gridItems = Array(repeating: GridItem(.flexible(), spacing: spacing), count: max(columns, 1))
                ScrollView {
//                    HStack {
//                        Button {
//                            folderViewModel.closeFolder()
//                        } label: {
//                            Image(systemName: "chevron.left")
//                        }
//                        .disabled(folderViewModel.getPath().count() == 1)
//                        .buttonStyle(PlainButtonStyle())
//                        .font(.title2)
//                        .padding(.bottom)
//                        Spacer()
//                        Menu(content: {
//                            Button {
//                                dataViewModel.coreDataManager.folderManager.createFolder(parentFolder: openFolder, name: "Nova Pasta")
//                            } label: {
//                                Text("Nova Pasta")
//                                Image(systemName: "folder")
//                            }
//                            Button {
//                                folderViewModel.importPDF(parentFolder: openFolder, dataViewModel: dataViewModel)
//                            } label: {
//                                Text("Importar PDF")
//                                Image(systemName: "doc")
//                            }
//                        }, label: {
//                            Image(systemName: "plus")
//                        })
//                        .buttonStyle(PlainButtonStyle())
//                        .font(.title2)
//                        .padding(.bottom)
//                    }
                    VStack {
                        List {
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
            }
        }
    }
}
