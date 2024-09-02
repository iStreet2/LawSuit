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
	
	@ObservedObject var CloudVM = CloudViewModel()
	
	@State var rotationEffect: Double = 0
	
	var body: some View {
		ZStack {
			VStack {
				HStack(alignment: .top) {
					fetchButtons

					Spacer()
					
					Button("Empty Arrays") {
						CloudVM.emptyAllArrays(areYouSure: true)
					}
				}
				.padding(.horizontal, 50)
				
				fileList
				
				folderList
				
				clientList
				
			}
			
			if CloudVM.loading {
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
			Text("Files: \(CloudVM.currentFiles.count)")
				.font(.title)
			
			ForEach(CloudVM.currentFiles, id:\.recordName) { obj in
				Text(obj.recordName ?? "Object here!")
			}
		}
	}
	
	private var folderList: some View {
		List {
			Text("Folders: \(CloudVM.currentFolders.count)")
				.font(.title)
			
			ForEach(CloudVM.currentFolders, id:\.recordName) { folder in
				Text(folder.recordName ?? "")
			}
		}
	}
	
	private var clientList: some View {
		List {
			Text("Clients: \(CloudVM.currentClients.count)")
				.font(.title)
			
			ForEach(CloudVM.currentClients, id:\.recordName) { client in
				Text(client.recordName ?? "")
			}
		}
	}
	
	private var fetchButtons: some View {
		VStack(alignment: .leading) {
			Button("Fetch Files") {
				Task {
					await CloudVM.getObjectsWith(query: .file)
				}
			}
			Button("Fetch Folders") {
				Task {
					await CloudVM.getObjectsWith(query: .folder)
				}
			}
			Button("Fetch Client") {
				Task {
					await CloudVM.getObjectsWith(query: .client)
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
