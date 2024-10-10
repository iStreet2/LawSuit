//
//  LawSuitApp.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 09/08/24.
//

import SwiftUI
import HotKey
import PDFKit

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
					 .sheet(isPresented: $dataViewModel.spotlightManager.shouldShowFilePreview) {
						 OpenFilePDFView(selectedFile: $dataViewModel.spotlightManager.fileToShow)
					 }
                .background(MaterialWindow().ignoresSafeArea())
                .toolbar(){
                    ToolbarItem(placement: .primaryAction){
                        Button(action: {
                            self.eventManager.spotlightBarIsPresented.toggle()
                        }){
                            Image(systemName: "magnifyingglass")
                        }
                    }
                }
        }
		 WindowGroup(id: "FileWindow", for: Data.self) { fileData in
			 if let data = fileData.wrappedValue {
				 if let filePDF = PDFDocument(data: data) {
					 PDFKitView(pdfDocument: filePDF)
						 .frame(minWidth: 300, minHeight: 400)
				 }
			 }
		 }
        
    }
}
