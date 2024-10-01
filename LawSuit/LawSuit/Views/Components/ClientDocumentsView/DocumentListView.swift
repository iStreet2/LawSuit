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
                        .frame(width: geometry.size.width * 0.64, alignment: .leading)
                    //                        .border(Color.black)
                    
                    Text("Tamanho")
                        .frame(width: geometry.size.width * 0.09, alignment: .leading)
                    //                        .border(Color.black)
                    
                    Text("Tipo")
                        .frame(width: geometry.size.width * 0.08, alignment: .leading)
                    //                        .border(Color.black)
                    
                    Text("Data de criação")
                        .frame(width: geometry.size.width * 0.10, alignment: .leading)
                }
                .padding(.leading, 20)
                .frame(minWidth: 777)
                .frame(height: 13)
                .font(.footnote)
                .bold()
                .foregroundStyle(Color(.gray))
                
                VStack {
                    Divider()
                    
                    if openFolder.folders!.count == 0 && openFolder.files!.count == 0{
                        Text("Sem pastas ou arquivos")
                            .foregroundStyle(.gray)
                            .frame(height: geometry.size.height / 2)
                    }
                    
                    ScrollView {
                        
                        VStack(alignment: .leading) {
                            FolderView(parentFolder: openFolder, geometry: geometry)
                                .onTapGesture(count: 2) {
                                    folderViewModel.openFolder(folder: openFolder)
                                }
                            FilePDFGridView(parentFolder: openFolder, geometry: geometry)
                            
                        }
                        .padding(.leading, 10)
                    }
                }
                .background(.black.opacity(0.01))
                
            }
            .padding(.top, 11)
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
                        .resizable()
                    
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

