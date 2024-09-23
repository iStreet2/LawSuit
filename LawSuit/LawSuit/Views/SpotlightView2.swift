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
			
			if let currentRecordable = currentRecordable {
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
			do {
				let clients: [Client] = try vm.fetchCoreDataObjects(for: .client)
				let files: [FilePDF] = try vm.fetchCoreDataObjects(for: .file)
				let lawsuits: [Lawsuit] = try vm.fetchCoreDataObjects(for: .lawsuit)
				
				vm.indexObjectsToSpotlight(objects: clients, for: .client)
				vm.indexObjectsToSpotlight(objects: files, for: .file)
				vm.indexObjectsToSpotlight(objects: lawsuits, for: .lawsuit)
				
			} catch {
				print("Error onAppear: \(error)")
			}
		}
	}
}
