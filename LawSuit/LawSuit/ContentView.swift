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
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    @State var navigationVisibility: NavigationSplitViewVisibility = .automatic
    
    var isLawsuit: Bool {
        switch selectedView {
        case .clients:
            false
        case .lawsuits:
            true
        }
    }
    
    var body: some View {
        HStack (spacing: 0){
            
            SideBarView(selectedView: $selectedView)
            
            ZStack{
                Color.white
                NavigationSplitView(columnVisibility: isLawsuit ? .constant(.detailOnly) : $navigationVisibility) {
                    if #available(macOS 14.0, *) {
                        ClientListView(addClient: $addClient, deleted: $deleted)
                            .frame(minWidth: 170)
                            .toolbar(removing: isLawsuit ? .sidebarToggle : nil)
                    } else {
                        ClientListView(addClient: $addClient, deleted: $deleted)
                            .frame(minWidth: 170)
                        
                    }
                    
                } detail: {
                    switch selectedView {
                    case .clients:
                        if let selectedClient = navigationViewModel.selectedClient {
                            ClientView(client: selectedClient, deleted: $deleted)
                                .background(.white)
                            
                        } else {
                            VStack{
                                Text("Selecione um cliente")
                                    .padding()
                                    .foregroundColor(.gray)
                            }
                            .background(.white)
                        }
                        
                    case .lawsuits:
                        LawsuitListView()
                            .background(.white)
                    }
                }
            }
        }
        .navigationTitle("Arqion")
        .sheet(isPresented: $addClient, content: {
            AddClientView()
        })
    }
}

enum SelectedView: String {
    case clients = "clients"
    case lawsuits = "lawsuits"
}
