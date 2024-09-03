//
//  SelecClientView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import SwiftUI

struct ClientListView: View {
    
    //MARK: Variáveis de estado
    @Binding var addClient: Bool
    @Binding var deleted: Bool
    
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
                    addClient.toggle()
                }, label: {
                    Image(systemName: "plus")
                })
            }
            .padding()
            List(clients, id: \.id) { client in
                Button(action: {
                    coreDataViewModel.clientManager.selectedClient = client
                    folderViewModel.resetFolderStack()
                    folderViewModel.openFolder(folder: client.rootFolder)
                    deleted = false
                }, label: {
                    HStack {
                        if coreDataViewModel.clientManager.selectedClient == client {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.gray)
                                    .opacity(0.4)
                                Text(client.name)
                                    .padding(.leading,10)
                            }
                        } else {
                            Text(client.name)
                                .padding(.leading,10)
                        }
                        Spacer()
                    }
                })
                // Fundo cinza se selecionado
                .buttonStyle(PlainButtonStyle())
            }
        }
        .background(.white)
    }
        
}

