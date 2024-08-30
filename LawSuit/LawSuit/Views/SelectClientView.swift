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
    @Binding var addClient: Bool
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Clientes")
                    .font(.title)
                    .bold()
                Button(action: {
                    withAnimation(.bouncy) {
                        addClient.toggle()
                    }
                }, label: {
                    Image(systemName: "plus")
                })
            }
            .padding()
            List(clients, id: \.id) { client in
                Button(action: {
                    selectedClient = client
                    folderViewModel.resetFolderStack()
                    folderViewModel.openFolder(folder: client.rootFolder)
                    
                }, label: {
                    Text(client.name)
                })
                .buttonStyle(PlainButtonStyle())
                .padding(.top)
            }
        }
        .background(.white)
        .onAppear {
            //MARK: APENAS PARA TESTES, RETIRAR DEPOIS
//            if clients.isEmpty {
//                coreDataViewModel.clientManager.testClient()
//            }
        }
    }
        
}

