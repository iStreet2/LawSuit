//
//  NavigationViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 04/09/24.
//

import Foundation


class NavigationViewModel: ObservableObject {
    
    @Published var selectedClient: Client? = nil
    @Published var isClientSelected: Bool = false
    @Published var isShowingDetailedLawsuitView = false
	 @Published var lawsuitToShow: Lawsuit? = nil
	
	func clearLawsuitAttributes() {
		self.lawsuitToShow = nil
	}
}

//struct ContentView: View {
//	 
//
//		  
//	 var body: some View {
//		  HStack (spacing: 0){
//				
//				SideBarView(selectedView: $selectedView)
//				
//				ZStack{
//					 Color.white
//					 NavigationSplitView(columnVisibility: isLawsuit ? .constant(.detailOnly) : $navigationVisibility) {
//						  if #available(macOS 14.0, *) {
//								ClientListView(addClient: $addClient, deleted: $deleted)
//									 .frame(minWidth: 170)
//									 .toolbar(removing: isLawsuit ? .sidebarToggle : nil)
//						  } else {
//								ClientListView(addClient: $addClient, deleted: $deleted)
//									 .frame(minWidth: 170)
//						  }
//						  
//					 } detail: {
//						  NavigationStack {
//								switch selectedView {
//								case .clients:
//									 if let selectedClient = navigationViewModel.selectedClient {
//										  ClientView(client: selectedClient, deleted: $deleted)
//												.background(.white)
//									 } else {
//										  VStack{
//												Text("Selecione um cliente")
//													 .padding()
//													 .foregroundColor(.gray)
//										  }
//										  .background(.white)
//									 }
//									 
//								case .lawsuits:
//									 LawsuitListView()
//										  .background(.white)
//								}
//								
//								// Adicionando navigationDestination dentro do NavigationStack
//								.navigationDestination(isPresented: $navigationViewModel.isShowingDetailedLawsuitView) {
//									 if let lawsuit = navigationViewModel.lawsuitToShow {
//										  DetailedLawSuitView(lawsuit: lawsuit, lawsuitCategory: TagType(s: lawsuit.category)!)
//									 }
//								}
//						  }
//					 }
//				}
//		  }
//		  .navigationTitle("Arqion")
//		  .sheet(isPresented: $addClient, content: {
//				AddClientView()
//		  })
//	 }
//}
