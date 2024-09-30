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
        VStack(alignment: .leading) {
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
            
            GeometryReader { geometry in
                VStack{
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
                    
                    ScrollView {
                        VStack(alignment: .leading) {
                            FolderView(parentFolder: openFolder, geometry: geometry)
                                .onTapGesture(count: 2) {
                                    folderViewModel.openFolder(folder: openFolder)
                                }
                            FilePDFGridView(parentFolder: openFolder, geometry: geometry)
                        }
                        if openFolder.folders!.count == 0 && openFolder.files!.count == 0{
                            Text("Sem pastas ou arquivos")
                                .foregroundStyle(.gray)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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

