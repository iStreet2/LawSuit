//
//  PathViewComponent.swift
//  LawSuit
//
//  Created by Giovanna Micher on 27/09/24.
//

import SwiftUI

struct PathViewComponent: View {
    
    //MARK: Variáveis de estado
    @ObservedObject var openFolder: Folder
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var dragAndDropViewModel: DragAndDropViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        HStack {
            ForEach(Array(folderViewModel.getPath().getItens().enumerated()), id: \.offset) { index, folder in
                Group {
                    if index == 0 {
                        if folder.name == "client" {
                            if let client = navigationViewModel.selectedClient {
                                if let socialName = client.socialName {
                                    Text("Documentos de \(String(describing: socialName.split(separator: " ").first ?? ""))")
                                } else {
                                    Text("Documentos de \(String(describing: client.name.split(separator: " ").first ?? ""))")
                                }
                            }
                        } else if folder.name == "lawsuit" {
                            Text("Documentos do Processo")
                        } else {
                            Text(folder.name)
                        }
                        Text("/")
                    } else {
                        Text(folder.name)
                        Text("/")
                    }
                }
                .font(.callout)
                .bold()
                .foregroundStyle(Color.gray)
                .onDrop(of: ["public.folder", "public.file-url"], isTargeted: nil) { providers in
                    withAnimation {
                        if let movingFolder = dragAndDropViewModel.movingFolder {
                            if let parentFolder = movingFolder.parentFolder {
                                if folder.id != parentFolder.id {
                                    dataViewModel.coreDataManager.folderManager.moveFolder(parentFolder: parentFolder, movingFolder: movingFolder, destinationFolder: folder)
                                    dragAndDropViewModel.movingFolder = nil
                                    return true
                                }
                            }
                        } else if let movingFilePDF = dragAndDropViewModel.movingFilePDF {
                            if let parentFolder = movingFilePDF.parentFolder {
                                dataViewModel.coreDataManager.filePDFManager.moveFilePDF(parentFolder: parentFolder, movingFilePDF: movingFilePDF, destinationFolder: folder)
                                dragAndDropViewModel.movingFilePDF = nil
                                return true
                            }
                        }
                        dragAndDropViewModel.movingFolder = nil
                        dragAndDropViewModel.movingFilePDF = nil
                        return false
                    }
                }
            }
        }
        .padding()
    }
}
