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
//            ContentView()
//            DocumentView()

            EditProcessAuthorComponent()

            SelectClientView()
//			  CloudTestingView()

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
