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
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>
    
    
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
                    deleted = false
                }, label: {
                    HStack {
                        if navigationViewModel.selectedClient == client {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.gray)
                                    .opacity(0.4)
                                if let socialName = client.socialName {
                                    Text(socialName)
                                        .padding(.leading,10)
                                } else {
                                    Text(client.name)
                                        .padding(.leading,10)
                                }
                            }
                        } else if let socialName = client.socialName{
                            Text(socialName)
                                .padding(.leading,10)
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
            Button {
                let lawyer = lawyers[0]
                for i in 0...10 {
                    dataViewModel.coreDataManager.clientManager.createClient(name: "Test\(i)", socialName: "testSocial\(i)", occupation: "Hom", rg: "593925178", cpf: "570.067.128-07", lawyer: lawyer, affiliation: "Hom", maritalStatus: "Hom", nationality: "Hom", birthDate: Date.now, cep: "05427005", address: "Hom", addressNumber: "472389", neighborhood: "Hom", complement: "Hom", state: "Hom", city: "Hom", email: "gabrielvicentinnegro@hotmail.com", telephone: "(11) 84435268", cellphone: "(11) 984435268")
                }
            } label: {
                Text("Criar vários clientes")
            }
        }
        .background(.white)
    }
        
}

