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
                    if folder.name == "client" {
                        if let client = navigationViewModel.selectedClient {
                            if let socialName = client.socialName {
                                Text(index == 0 ? "Documentos de \(String(describing: socialName.split(separator: " ").first ?? ""))" : folder.name)
                                Text("/")
                            } else {
                                Text(index == 0 ? "Documentos de \(String(describing: client.name.split(separator: " ").first ?? ""))" : folder.name)
                                Text("/")
                            }
                            
                        }
                    } else {
                        Text(index == 0 ? "Documentos do processo" : folder.name)
                        Text("/")
                    }
                }
                .font(.callout)
                .bold()
                .foregroundStyle(Color.gray)
                .onDrop(of: ["public.folder", "public.file-url"], isTargeted: nil) { providers in
                    if let movingFolder = dragAndDropViewModel.movingFolder {
                        dataViewModel.coreDataManager.folderManager.moveFolder(parentFolder: openFolder, movingFolder: movingFolder, destinationFolder: folder)
                    }
                    return true
                }
            }
            
        }
        .padding(.horizontal)
    }
}
