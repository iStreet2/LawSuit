//
//  SelecClientView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 15/08/24.
//

import SwiftUI

struct ClientListView: View {
    
    //MARK: Variáveis de estado
    @State var deleteAlert = false
    @State var clientToDelete: Client? = nil
    @State var selectedClients: Set<Client> = []
    @Binding var addClient: Bool
    @Binding var deleted: Bool
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Client.name, ascending: true)]) var clients: FetchedResults<Client>
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
                    if NSEvent.modifierFlags.contains(.command) {
                        if selectedClients.contains(client) {
                            selectedClients.remove(client)
                        } else {
                            selectedClients.insert(client)
                        }
                    } else {
                        navigationViewModel.selectedClient = client
                        navigationViewModel.isShowingDetailedLawsuitView = false
                        folderViewModel.resetFolderStack()
                        folderViewModel.openFolder(folder: client.rootFolder)
                        selectedClients.removeAll()
                        deleted = false
                    }
                }, label: {
                    HStack {
                        if navigationViewModel.selectedClient == client && selectedClients.isEmpty {
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
                        } else if selectedClients.contains(client) {
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundStyle(.blue)
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
                .contextMenu {
                    Group {
                        if !selectedClients.isEmpty {
                            Button {
                                deleteAlert.toggle()
                            } label: {
                                Text("Deletar Selecionados (\(selectedClients.count))")
                                Image("trash")
                            }
                        } else {
                            Button {
                                deleteAlert.toggle()
                                clientToDelete = client
                            } label: {
                                Image(systemName: "trash")
                                Text("Deletar")
                            }
                            Button {
                                
                            } label: {
                                Image(systemName: "pencil")
                                Text("Editar")
                            }
                        }
                    }
                    .tint(.red)
                }
            }
            .alert(isPresented: $deleteAlert, content: {
                Alert(
                    title: Text("Você tem certeza?"),
                    message: Text("Excluir o cliente \(clientToDelete?.name ?? "") irá apagar todos os dados relacionados a ele, incluindo seus processos!"),
                    primaryButton: Alert.Button.destructive(Text("Apagar"), action: {
                        if !selectedClients.isEmpty {
                            for client in selectedClients {
                                if let lawsuits = dataViewModel.coreDataManager.lawsuitManager.fetchFromClient(client: client) {
                                    for lawsuit in lawsuits {
                                        dataViewModel.coreDataManager.lawsuitManager.deleteLawsuit(lawsuit: lawsuit)
                                    }
                                    dataViewModel.coreDataManager.clientManager.deleteClient(client: client)
                                    navigationViewModel.selectedClient = nil
                                    selectedClients.removeAll()
                                    deleted.toggle()
                                }
                            }
                        } else {
                            if let clientToDelete = clientToDelete,
                            let lawsuits = dataViewModel.coreDataManager.lawsuitManager.fetchFromClient(client: clientToDelete) {
                                for lawsuit in lawsuits {
                                    dataViewModel.coreDataManager.lawsuitManager.deleteLawsuit(lawsuit: lawsuit)
                                }
                                // Após deletar os processos, deletar o cliente
                                dataViewModel.coreDataManager.clientManager.deleteClient(client: clientToDelete)
                                navigationViewModel.selectedClient = nil
                                deleted.toggle()
                                self.clientToDelete = nil
                            }
                        }
                        deleteAlert = false
                    }),
                    secondaryButton: Alert.Button.cancel(Text("Cancelar"))
                )
            })
            
            //MARK: Botão para criar vários clientes
//            Button {
//                var photoData:Data? = Data()
//                folderViewModel.importPhoto { data in
//                    photoData = data
//                    let lawyer = lawyers[0]
//                    for i in 0...10 {
//                        dataViewModel.coreDataManager.clientManager.createClient(name: "Test\(i)", socialName: "testSocial\(i)", occupation: "Hom", rg: "593925178", cpf: "570.067.128-07", lawyer: lawyer, affiliation: "Hom", maritalStatus: "Hom", nationality: "Hom", birthDate: Date.now, cep: "05427005", address: "Hom", addressNumber: "472389", neighborhood: "Hom", complement: "Hom", state: "Hom", city: "Hom", email: "gabrielvicentinnegro@hotmail.com", telephone: "(11) 84435268", cellphone: "(11) 984435268", photo: photoData)
//                    }
//                }
//            } label: {
//                Text("Criar vários clientes")
//            }
        }
        .background(.white)
    }
        
}

