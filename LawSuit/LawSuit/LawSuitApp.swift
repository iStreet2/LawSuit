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
    @StateObject var lawsuitViewModel = LawsuitViewModel()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let hotkey = HotKey(key: .i, modifiers: [.command, .shift])
    
    var body: some Scene {
        WindowGroup {
			  MainView()
                .environment(\.managedObjectContext, dataViewModel.coreDataContainer.viewContext)
                .environmentObject(dataViewModel)
                .environmentObject(folderViewModel)
                .environmentObject(dragAndDropViewModel)
                .environmentObject(networkMonitor)
                .environmentObject(navigationViewModel)
                .environmentObject(clientDataViewModel)
                .environmentObject(addressViewModel)
					      .environmentObject(eventManager)
                .environmentObject(lawsuitViewModel)
                .preferredColorScheme(.light)
					 .frame(/*minWidth: 850, */minHeight: 530) // TODO: Setar o minWidth do jeito certo, aqui quebra rs
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
					 .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("HandleSpotlightSearch")), perform: { notification in
						 if let uniqueIdentifier = notification.object as? String {
							 print(uniqueIdentifier)
							 let currentRecordable = dataViewModel.getObjectByURI(uri: uniqueIdentifier)
							 print(currentRecordable)
							 
							 if let client = currentRecordable as? Client {
//								 self.currentClient = client
								 navigationViewModel.selectedClient = client
							 } else {
								 print("Object is not a client, \(type(of: currentRecordable))")
							 }
						 }
					 })
                
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
