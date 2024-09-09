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
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
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
                .bold()
                .foregroundStyle(.secondary)
                .font(.title2)
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            List(clients, id: \.id) { client in
                Button(action: {
                    navigationViewModel.selectedClient = client
                    folderViewModel.resetFolderStack()
                    folderViewModel.openFolder(folder: client.rootFolder)
                    navigationViewModel.dismissLawsuitView.toggle()
                    deleted = false
                }, label: {
                    HStack {
                        if navigationViewModel.selectedClient == client {
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

