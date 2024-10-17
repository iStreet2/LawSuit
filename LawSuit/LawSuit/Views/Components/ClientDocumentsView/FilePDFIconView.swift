//
//  FilePDFIconView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//

import SwiftUI

struct FilePDFIconView: View {
    
    //MARK: Variáveis
    @ObservedObject var filePDF: FilePDF
    @ObservedObject var parentFolder: Folder
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    
    var body: some View {
        Group {
            if folderViewModel.showingGridView {
                VStack {
                    Image(systemName: "doc")
                        .font(.system(size: 55))
                        .background(.clear)
                    if filePDF.isEditing {
                        TextField("", text: Binding(
                            get: { filePDF.name ?? "Sem nome" },
                            set: { newValue in
                                filePDF.name = newValue
                            }
                        ), onCommit: {
                            saveChanges()
                        })
                        .lineLimit(1)
                        .frame(height: 4)
                    }
                    else {
                        Text(filePDF.name ?? "Sem nome")
                            .lineLimit(1)
                            .onTapGesture(count: 2) {
                                filePDF.isEditing = true // Inicia a edição
                            }
                    }
                }
                .onDisappear {
                    filePDF.isEditing = false // Para edição quando a view desaparecer
                }
                .onAppear {
                    if filePDF.name == "Novo Arquivo" {
                        filePDF.isEditing = true
                    }
                }
            } else {
                
                HStack {
                    Image(systemName: "doc")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .font(.system(size: 55))
                    
                    if filePDF.isEditing {
                        TextField("", text: Binding(
                            get: { filePDF.name ?? "Sem nome" },
                            set: { newValue in
                                filePDF.name = newValue
                            }
                        ), onCommit: {
                            saveChanges()
                        })
                        .lineLimit(1)
                        .frame(height: 4)
                    } else {
                        Text(filePDF.name ?? "Sem nome")
                            .lineLimit(1)
                            .onTapGesture(count: 2) {
                                filePDF.isEditing = true // Inicia a edição
                            }
                    }
                }
            }
        }
        .contextMenu {
            Button(action: {
                //MARK: Fazer a view de visualizar um pdf ainda
                
            }) {
                Text("Abrir Arquivo")
                Image(systemName: "doc")
            }
            Button(action: {
                filePDF.isEditing = true // Ativa edição pelo menu de contexto
            }) {
                Text("Renomear")
                Image(systemName: "pencil")
            }
            Button(action: {
                // Ação para excluir o arquivo
                withAnimation(.easeIn) {
                    dataViewModel.coreDataManager.filePDFManager.deleteFilePDF(parentFolder: parentFolder, filePDF: filePDF)
                }
            }) {
                Text("Excluir")
                Image(systemName: "trash")
            }
            Button {
                withAnimation {
                    if let destinationFolder = parentFolder.parentFolder {
                        dataViewModel.coreDataManager.filePDFManager.moveFilePDF(parentFolder: parentFolder, movingFilePDF: filePDF, destinationFolder: destinationFolder)
                    }
                }
            } label: {
                Text("Mover para pasta anterior")
                Image(systemName: "arrowshape.turn.up.left")
            }
            .disabled(parentFolder.parentFolder == nil)
        }
        .onDrag {
            dragAndDropViewModel.movingFilePDF = filePDF
            // Gera uma URL temporária para o PDF
            let tempDirectory = FileManager.default.temporaryDirectory
            let tempPDFURL = tempDirectory.appendingPathComponent(filePDF.name ?? "Sem nome")
            
            // Escreve os dados do PDF no local temporário
            try? filePDF.content?.write(to: tempPDFURL)
            
            // Retorna o NSItemProvider com a URL do PDF temporário
            return NSItemProvider(object: tempPDFURL as NSURL)
        }
    }
    
    private func saveChanges() {
        dataViewModel.coreDataManager.filePDFManager.editFilePDFName(filePDF: filePDF, name: filePDF.name ?? "Sem nome")
        filePDF.isEditing = false // Salva e encerra a edição
    }
}
