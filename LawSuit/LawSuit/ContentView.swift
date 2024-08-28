//
//  ContentView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/08/24.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var folderViewModel: FolderViewModel
//    
//    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    @State private var selectedView = SelectedView.clients
    @State private var selectedClient: Client?
    
    var body: some View {   
        HStack {
            SideBarView(selectedView: $selectedView)
            
            switch selectedView {
            case .clients:
                NavigationSplitView {
                    SelectClientView(selectedClient: $selectedClient)
                } detail: {
                    if let selectedClient = selectedClient {
                        DocumentView(client: selectedClient)
                    } else {
                        Text("Selecione um cliente")
                            .foregroundColor(.gray)
                    }
                }
                
            case .lawsuits:
                //MARK: Inserir View de Processos
                Divider()
                Spacer()
                Text("Aqui sera a view de processos")
                Spacer()
            }
        }
        
    }
}

enum SelectedView: String {
    case clients = "clients"
    case lawsuits = "lawsuits"
}
