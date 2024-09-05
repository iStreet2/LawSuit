//
//  ContentView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/08/24.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: Variáveis de estado
    @State private var selectedView = SelectedView.clients
    @State private var selectedClient: Client?
    @State private var addClient = false
    @State var deleted = false
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    var body: some View {
        HStack {
            SideBarView(selectedView: $selectedView)
            switch selectedView {
            case .clients:
                NavigationSplitView {
                    ClientListView(addClient: $addClient, deleted: $deleted)
                        .frame(minWidth: 170)
                } detail: {
                    if let selectedClient = navigationViewModel.selectedClient {
                        ClientView(client: selectedClient, deleted: $deleted)
                    } else {
                        Text("Selecione um cliente")
                            .foregroundColor(.gray)
                    }
                }
            case .lawsuits:
                Divider()
                Spacer()
                LawsuitListView()
                Spacer()
            }
        }
        .sheet(isPresented: $addClient, content: {
            AddClientView()
        })
    }
}

enum SelectedView: String {
    case clients = "clients"
    case lawsuits = "lawsuits"
}
