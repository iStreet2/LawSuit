//
//  DocumentView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//

import SwiftUI
import CoreData

struct DocumentView: View {
    
    @EnvironmentObject var folderViewModel: FolderViewModel

    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    @ObservedObject var client: Client
    
    var body: some View {
        VStack {
            ClientInfoView(client: client)
            Divider()
            if let openFolder = folderViewModel.getOpenFolder() {
                DocumentGridView(parentFolder: openFolder)
                    .padding()
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
            }
        }
        .toolbar {
            ToolbarItem(placement: .destructiveAction) {
                Button(action: {
                    coreDataViewModel.deleteAllData()
                }, label: {
                    Image(systemName: "trash")
                })
            }
            ToolbarItem(placement: .navigation) {
                Button {
                    folderViewModel.closeFolder()
                    print(folderViewModel.getPath())
                } label: {
                    Image(systemName: "chevron.left")
                }
                .disabled(folderViewModel.getPath().count() == 1)
            }
        }
    }
}

