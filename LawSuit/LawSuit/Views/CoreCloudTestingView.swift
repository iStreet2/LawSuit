//
//  CoreCloudTestingView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 02/09/24.
//

import Foundation
import SwiftUI
import CloudKit

struct CoreCloudTestingView: View {
	
	@ObservedObject var dataViewModel = DataViewModel()
	
	@State var rotationEffect: Double = 0
	
	var body: some View {
		ZStack {
			VStack {
				HStack(alignment: .top) {
					fetchButtons

					Spacer()
					
					Button("Empty Arrays") {
                        dataViewModel.cloudManager.emptyAllArrays(areYouSure: true)
					}
				}
				.padding(.horizontal, 50)
				
				fileList
				
				folderList
				
				clientList
				
			}
			
            if dataViewModel.cloudManager.loading {
				loadingIcon
			}
		}
		.padding(.top)
		.frame(width: 500, height: 750)
	}
}

#Preview {
	CoreCloudTestingView()
}

extension CoreCloudTestingView {
	private var fileList: some View {
		List {
            Text("Files: \(dataViewModel.cloudManager.currentFiles.count)")
				.font(.title)
			
            ForEach(dataViewModel.cloudManager.currentFiles, id:\.recordName) { obj in
				Text(obj.recordName ?? "Object here!")
			}
		}
	}
	
	private var folderList: some View {
		List {
            Text("Folders: \(dataViewModel.cloudManager.currentFolders.count)")
				.font(.title)
			
            ForEach(dataViewModel.cloudManager.currentFolders, id:\.recordName) { folder in
				Text(folder.recordName ?? "")
			}
		}
	}
	
	private var clientList: some View {
		List {
            Text("Clients: \(dataViewModel.cloudManager.currentClients.count)")
				.font(.title)
			
            ForEach(dataViewModel.cloudManager.currentClients, id:\.recordName) { client in
				Text(client.recordName ?? "")
			}
		}
	}
	
	private var fetchButtons: some View {
		VStack(alignment: .leading) {
			Button("Fetch Files") {
				Task {
					await dataViewModel.cloudManager.getObjectsWith(query: .file)
				}
			}
			Button("Fetch Folders") {
				Task {
					await dataViewModel.cloudManager.getObjectsWith(query: .folder)
				}
			}
			Button("Fetch Client") {
				Task {
					await dataViewModel.cloudManager.getObjectsWith(query: .client)
				}
			}
		}
	}
	
	private var loadingIcon: some View {
		Image(systemName: "arrow.triangle.2.circlepath")
			.resizable()
			.scaledToFit()
			.frame(width: 50)
			.foregroundStyle(.white)
			.opacity(0.75)
			.rotationEffect(Angle(degrees: rotationEffect))
			.onAppear {
				withAnimation(.linear(duration: 1).repeatForever(autoreverses: false)) {
					rotationEffect = 360
				}
			}
			.onDisappear {
				rotationEffect = 0
			}
	}
}
