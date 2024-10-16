//
//  SpotlightView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/09/24.
//

import Foundation
import SwiftUI
import CoreServices

struct SpotlightView: View {
	
	@EnvironmentObject var vm: DataViewModel
	
	@State var currentClient: Client? = nil
	@State var currentFile: FilePDF? = nil
	@State var currentLawsuit: Lawsuit? = nil
	@State var currentRecordable: Recordable? = nil
	
	var body: some View {
		VStack {
			Text("SpotlightVioew")
				.font(.largeTitle)
			
			if currentRecordable != nil {
				if let client = currentClient {
					Text(client.name)
					Text(client.id)
					Text(client.cellphone)
				}
			} else {
				Text("nil")
					.foregroundStyle(.red)
					.font(.title)
			}
		}
		.onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("HandleSpotlightSearch")), perform: { notification in
			if let uniqueIdentifier = notification.object as? String {
				print(uniqueIdentifier)
				self.currentRecordable = vm.getObjectByURI(uri: uniqueIdentifier)
				
				if let client = currentRecordable as? Client {
					self.currentClient = client
				} else {
					print("Object is not a client, \(type(of: currentRecordable))")
				}
			}
		})
		.onAppear {
			let clients: [Client] =  vm.fetchCoreDataObjects(for: .client)
			let files: [FilePDF] =  vm.fetchCoreDataObjects(for: .file)
			let lawsuits: [Lawsuit] =  vm.fetchCoreDataObjects(for: .lawsuit)
			
			vm.indexObjectsToSpotlight(objects: clients, for: .client)
			vm.indexObjectsToSpotlight(objects: files, for: .file)
			vm.indexObjectsToSpotlight(objects: lawsuits, for: .lawsuit)
		}
	}
}
