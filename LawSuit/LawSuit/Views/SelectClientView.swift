//
//  SelecClientView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import SwiftUI

struct SelectClientView: View {
    
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    var body: some View {
        NavigationStack {
            //        ScrollView {
            List {
                ForEach(clients) { client in
                    NavigationLink {
                        DocumentView(client: client)
                    } label: {
                        Text(client.name)
                    }
                    
                }
            }
        }
        .onAppear {
            //             Criação de um cliente de teste
//            let client = Client(context: coreDataViewModel.context)
//            client.name = "Cliente teste"
//            client.age = Int64(32)
//            client.id = UUID().uuidString
//            
//            //             Criação da pasta root associada ao cliente
//            let folder = Folder(context: coreDataViewModel.context)
//            folder.name = "root\(client.name)"
//            folder.id = "root\(client.name)"
//            
//            //             Relacionando as entidades
//            folder.client = client
//            client.rootFolder = folder
//            
//            let subFolder = Folder(context: context)
//            subFolder.name = "oh meu deus"
//            subFolder.id = UUID().uuidString
//            subFolder.parentFolder = client.rootFolder
//            client.rootFolder.addToFolders(folder)
//            CoreDataViewModel().clientManager.saveContext()
//            print("sucesso")
        }
        //        }
    }
}

//#Preview {
//    SelectClientView()
//}
