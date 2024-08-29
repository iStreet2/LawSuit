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
            
//            AddClientView(clientMock: ClientMock(name: "", occupation: "", rg: "", cpf: "", affiliation: "", maritalStatus: "", nationality: "", birthDate: Date(), cep: "", address: "", addressNumber: "", neighborhood: "", complement: "", state: "", city: "", email: "", telephone: "", cellphone: ""))
            ContentView()
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
            
//                .environment(\.managedObjectContext, coreDataViewModel.container.viewContext)
//                .environmentObject(folderViewModel)
//                .environmentObject(coreDataViewModel)
//                .environmentObject(dragAndDropViewModel)
//                .environmentObject(networkMonitor)
//                 CheckboxView()
                .preferredColorScheme(.light)
        }
    }
}
