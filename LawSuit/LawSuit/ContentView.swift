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
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    
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
                    ClientListView(addClient: $addClient)
                        .frame(minWidth: 170)
                } detail: {
                    if let selectedClient = coreDataViewModel.clientManager.selectedClient {
                        DocumentView(client: selectedClient)
                    } else {
                        Text("Selecione um cliente")
                            .foregroundColor(.gray)
                    }
                }
            case .lawsuits:
                Divider()
                Spacer()
                LawsuitListView2()
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
