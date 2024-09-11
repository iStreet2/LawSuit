//
//  LawSuitApp.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/08/24.
//

import SwiftUI

@main
struct LawSuitApp: App {
    
    @StateObject var dataViewModel = DataViewModel()
    @StateObject var folderViewModel = FolderViewModel()
    @StateObject var dragAndDropViewModel = DragAndDropViewModel()
    @StateObject var networkMonitor = NetworkMonitorViewModel()
    @StateObject var navigationViewModel = NavigationViewModel()
    
    var body: some Scene {
        WindowGroup {   
			  ContentView()
                .environment(\.managedObjectContext, dataViewModel.coreDataContainer.viewContext)
                .environmentObject(dataViewModel)
                .environmentObject(folderViewModel)
                .environmentObject(dragAndDropViewModel)
                .environmentObject(networkMonitor)
                .environmentObject(navigationViewModel)
                .preferredColorScheme(.light)
                .frame(minHeight: 530)
        }
    }
}
