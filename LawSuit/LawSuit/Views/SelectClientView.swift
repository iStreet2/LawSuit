//
//  SelecClientView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import SwiftUI

struct SelectClientView: View {
    
    //MARK: Variáveis de estado
    @Binding var selectedClient: Client?
    
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Clientes")
                .font(.title)
                .bold()
            List(clients, id: \.id) { client in
                Button(action: {
                    selectedClient = client
                }, label: {
                    Text(client.name ?? "Cliente Sem Nome")
                })
            }
        }
        .padding()
        .background(.white)
        .onAppear {
            //MARK: APENAS PARA TESTES, RETIRAR DEPOIS
            if clients.isEmpty {
                coreDataViewModel.clientManager.testClient()
            }
        }
    }
        
}

