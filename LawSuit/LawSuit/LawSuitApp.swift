//
//  LawSuitApp.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/08/24.
//

import SwiftUI

@main
struct LawSuitApp: App {
    
    @StateObject var coreDataViewModel = CoreDataViewModel()
    @StateObject var folderViewModel = FolderViewModel()
    @StateObject var dragAndDropViewModel = DragAndDropViewModel()
    @StateObject var cloudViewModel = CloudViewModel()
    @StateObject var networkMonitor = NetworkMonitor()
    
    var body: some Scene {
        WindowGroup {
            
//            AddClientView()
//            ContentView()
//            DocumentView()
//            SelectClientView()
//                .environment(\.managedObjectContext, coreDataViewModel.container.viewContext)
//                .environmentObject(folderViewModel)
//                .environmentObject(coreDataViewModel)
//                .environmentObject(dragAndDropViewModel)
//            CheckboxView()
//                .preferredColorScheme(.light)
//			  CloudTestingView()

            //EditProcessAuthorComponent()

//            SelectClientView()
			  ProcessView(lawsuit:
				  LawsuitMock(actionDate: Date.now,
								  category: "civel",
								  defendant: "Abigail da Silva",
								  id: "sID",
								  name: "Nome do processo",
								  number: "0001234-56.2024.5.00.0000",
								  parentAutor: ClientMock(name: "Abigail da Silva",
													  occupation: "Desenvolvedora de Software",
													  rg: "123.456.789-0",
													  cpf: "123.456.789-00",
													  affiliation: "Afiliação",
													  maritalStatus: "Casada",
													  nationality: "Brasileira",
													  birthDate: Date.now,
													  cep: "04141900",
													  address: "Rua Da Sorte Lobinho",
													  addressNumber: "123",
													  neighborhood: "Lobo mau",
													  complement: "",
													  state: "São Jorge",
													  city: "Cidade Nacional do Brasil",
													  email: "abigail.silva@outlook.com.ru",
													  telephone: "(20)9345678123",
													  cellphone: "(20)0987654323",
													  age: 45),
								  parentLawyer: LawyerMock(id: "ID",
														name: "André Miguel da Silva",
														oab: "12O34A56B",
														photo: nil,
														clients: [],
														Lawsuit: [],
														recordName: ""),
								  rootFolder: FolderMock(),
								  recordName: "",
								  vara: "1 Vara do Trabalho de São Paulo"))
            
                .environment(\.managedObjectContext, coreDataViewModel.container.viewContext)
                .environmentObject(folderViewModel)
                .environmentObject(coreDataViewModel)
                .environmentObject(dragAndDropViewModel)
                .environmentObject(networkMonitor)
//            CheckboxView()
                .preferredColorScheme(.light)
        }
    }
}
