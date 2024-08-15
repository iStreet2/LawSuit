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
            if let openFolder = folderViewModel.openFolder {
                DocumentGridView(rootFolder: openFolder)
            }
        }
        .onAppear {
            folderViewModel.openFolder = client.rootFolder
            // Criação de um cliente de teste
//            let client = Client(context: coreDataViewModel.context)
//            client.name = "Cliente teste"
//            client.age = Int64(32)
//            client.id = UUID().uuidString
            
            // Criação da pasta root associada ao cliente
//            let folder = Folder(context: coreDataViewModel.context)
//            folder.name = "root\(client.name)"
//            folder.id = "root\(client.name)"
            
            // Relacionando as entidades
//            folder.client = client
//            client.rootFolder = folder
            
            // Salvando o contexto com tratamento de erros
//            coreDataViewModel.clientManager.saveContext()
//            let folder = Folder(context: context)
//            folder.name = "oh meu deus"
//            folder.id = UUID().uuidString
//            folder.client = clients[0]
//            clients[0].rootFolder.addToFolders(folder)
//            CoreDataViewModel().clientManager.saveContext()
        }

    }
}

//#Preview {
//    DocumentView()
//        .environmentObject(CoreDataViewModel())
//        .environmentObject(FolderViewModel())
//}

