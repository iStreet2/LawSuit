//
//  LawSuitApp.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/08/24.
//

import SwiftUI
import HotKey

@main
struct LawSuitApp: App {
    
    @StateObject var dataViewModel = DataViewModel()
    @StateObject var folderViewModel = FolderViewModel()
    @StateObject var dragAndDropViewModel = DragAndDropViewModel()
    @StateObject var networkMonitor = NetworkMonitorViewModel()
    @StateObject var navigationViewModel = NavigationViewModel()
    @StateObject var clientDataViewModel = TextFieldDataViewModel()
    @StateObject var addressViewModel = AddressViewModel()
	 @StateObject var eventManager = EventManager()

	@NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	
	 let hotkey = HotKey(key: .i, modifiers: [.command, .shift])
    
    var body: some Scene {
        WindowGroup {   
			  ContentView()
                .environment(\.managedObjectContext, dataViewModel.coreDataContainer.viewContext)
                .environmentObject(dataViewModel)
                .environmentObject(folderViewModel)
                .environmentObject(dragAndDropViewModel)
                .environmentObject(networkMonitor)
                .environmentObject(navigationViewModel)
                .environmentObject(clientDataViewModel)
                .environmentObject(addressViewModel)
                .preferredColorScheme(.light)
                .frame(minHeight: 530)
					 .onAppear {
						 hotkey.keyDownHandler = eventManager.hotkeyDownHandler
					 }
					 .sheet(isPresented: $eventManager.spotlightBarIsPresented) {
						 SpotlightSearchbarView()
							 .environmentObject(dataViewModel)
							 .environmentObject(navigationViewModel)
					 }
        }
    }
}
