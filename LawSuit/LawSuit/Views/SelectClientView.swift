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
        NavigationSplitView {
            List {
                ForEach(clients) { client in
                    NavigationLink {
                        DocumentView(client: client)
                            .padding()
                    } label: {
                        Text(client.name ?? "Sem nome")
                    }
                }
            }
            
        } detail : {
            Text("Nenhum cliente selecionado")
        }
        .onAppear {
            //MARK: APENAS PARA TESTES, RETIRAR DEPOIS
            if clients.isEmpty {
                coreDataViewModel.clientManager.testClient()
            }
        }
    }
}
