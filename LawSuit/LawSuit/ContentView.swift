//
//  ContentView.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/08/24.
//  Hello

import SwiftUI


struct ContentView: View {
    
    //MARK: Variáveis de estado
//    @State private var selectedView = SelectedView.clients
    @State private var selectedClient: Client?
    @State private var addClient = false
    @State var deleted = false
    
    //MARK: ViewModels
    @EnvironmentObject var folderViewModel: FolderViewModel
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var contactsManager: ContactsManager
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    @State var navigationVisibility: NavigationSplitViewVisibility = .automatic
    @State var showContactAlert: Bool = false
    
    var isLawsuit: Bool {
		 switch navigationViewModel.selectedView {
        case .clients:
            false
        case .lawsuits:
            true
		 case .plans:
			 false
        }
    }
    
    var body: some View {
        HStack(spacing: 0){
			  SideBarView(selectedView: $navigationViewModel.selectedView)
            ZStack{
                Color.white
					NavigationSplitView(columnVisibility: navigationViewModel.isLawsuit() ? .constant(.detailOnly) : $navigationViewModel.navigationVisibility) {
                    ClientListView(addClient: $addClient, deleted: $deleted)
                        .frame(minWidth: 170)
                        .toolbar(removing: isLawsuit ? .sidebarToggle : nil)
                } detail: {
                    NavigationStack {
							  switch navigationViewModel.selectedView {
                        case .clients:
                            if let selectedClient = navigationViewModel.selectedClient {
                                ClientView(client: selectedClient, deleted: $deleted)
                                    .background(.white)
                                    .navigationDestination(isPresented: $navigationViewModel.isShowingDetailedLawsuitView) {
                                        if let lawsuit = navigationViewModel.lawsuitToShow {
                                            let lawsuitData = dataViewModel.coreDataManager.getClientAndEntity(for: lawsuit)
                                            
                                            if let client = lawsuitData.client, let entity = lawsuitData.entity {
                                                DetailedLawSuitView(lawsuit: lawsuit, lawsuitCategory: TagType(s: lawsuit.category), client: client, entity: entity)
                                            }
                                            
                                        }
                                    }
                            } else {
                                VStack{
                                    if showContactAlert {
                                        Text("Cliente adicionado aos contatos!")
                                            .font(.body)
                                            .foregroundStyle(.secondary)
                                            .padding()
                                            .background(Color.gray.opacity(0.1))
                                            .clipShape(RoundedRectangle(cornerRadius: 7))
                                            .transition(.opacity)
                                            .onAppear {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                    withAnimation {
                                                        showContactAlert = false
                                                    }
                                                }
                                            }
                                    } else {
                                        ClientEmptyState(addClient: $addClient)
                                    }
                                }
                                .background(.white)
                                .navigationDestination(isPresented: $navigationViewModel.isShowingDetailedLawsuitView) {
                                    if let lawsuit = navigationViewModel.lawsuitToShow {
                                        let lawsuitData = dataViewModel.coreDataManager.getClientAndEntity(for: lawsuit)
                                        
                                        if let client = lawsuitData.client, let entity = lawsuitData.entity {
                                            DetailedLawSuitView(lawsuit: lawsuit, lawsuitCategory: TagType(s: lawsuit.category), client: client, entity: entity)
                                        }
                                            
                                    }
                                }
                            }
                            
                        case .lawsuits:
                            LawsuitListView(addClient: $addClient)
                                .background(.white)
                                .navigationDestination(isPresented: $navigationViewModel.isShowingDetailedLawsuitView) {
                                    if let lawsuit = navigationViewModel.lawsuitToShow {
                                        let lawsuitData = dataViewModel.coreDataManager.getClientAndEntity(for: lawsuit)
                                        
                                        if let client = lawsuitData.client, let entity = lawsuitData.entity {
                                            DetailedLawSuitView(lawsuit: lawsuit, lawsuitCategory: TagType(s: lawsuit.category), client: client, entity: entity)
                                        }
                                        
                                    }
                                }
								  
							  case .plans:
								  SubscriptionPlansView()
                        }
                        
                    }
                }
            }
            
        }
        .navigationTitle("Arqion")
        .sheet(isPresented: $addClient, content: {
            AddClientView()
        })
        .alert(isPresented: $contactsManager.showAlert) {
            Alert(title: Text("Aviso"),
                  message: Text(contactsManager.alertMessage),
                  dismissButton: .default(Text("Ok")))
        }
    }
}

enum SelectedView: String {
    case clients = "clients"
    case lawsuits = "lawsuits"
	 case plans = "plans"
}

