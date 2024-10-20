//
//  SpotlightSearchbarView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 17/09/24.
//

import SwiftUI

struct SpotlightSearchbarView: View {
	
	@Environment(\.dismiss) var dismiss
	@Environment(\.openWindow) var openWindow
	
	@EnvironmentObject var dataViewModel: DataViewModel
	@EnvironmentObject var navigationViewModel: NavigationViewModel
	
	@State var searchString: String = ""
	
	@State var currentEntity: (any EntityWrapper)? = nil
	
	//	@State var currentClientList: [ClientWrapper] = []
	//	@State var currentLawsuitList: [LawsuitWrapper] = []
	//	@State var currentFileList: [FileWrapper] = []
	
	
	// Handle entity tap logic
	private func handleEntityTap(for entity: any EntityWrapper) {
		if let clientWrapper = entity as? ClientWrapper {
			navigationViewModel.selectedClient = clientWrapper.client
		} else if let lawsuitWrapper = entity as? LawsuitWrapper {
			navigationViewModel.lawsuitToShow = lawsuitWrapper.lawsuit
			navigationViewModel.isShowingDetailedLawsuitView = true
		} else if let fileWrapper = entity as? FileWrapper {
			dismiss()
			openWindow(value: fileWrapper.file.content!)
//			dataViewModel.spotlightManager.fileToShow = fileWrapper.file
//			dataViewModel.spotlightManager.shouldShowFilePreview = true
		}
		dismiss()
	}
	
	// Handles submit action for search
	private func handleSubmit() {
		if let clientWrapper = currentEntity as? ClientWrapper {
			navigationViewModel.selectedClient = clientWrapper.client
		} else if let lawsuitWrapper = currentEntity as? LawsuitWrapper {
			navigationViewModel.lawsuitToShow = lawsuitWrapper.lawsuit
			navigationViewModel.isShowingDetailedLawsuitView = true
		} else if let fileWrapper = currentEntity as? FileWrapper {
			dismiss()
			openWindow(value: fileWrapper.file.content!)
//			dataViewModel.spotlightManager.fileToShow = fileWrapper.file
//			dataViewModel.spotlightManager.shouldShowFilePreview = true
		}
		dismiss()
	}
	
	
	var body: some View {
		VStack {
			HStack {
				Image(systemName: "magnifyingglass")
				TextField("", text: $searchString, prompt: Text("Pesquisar"))
					.textFieldStyle(PlainTextFieldStyle())
					.onSubmit {
						handleSubmit()
					}
			}
			.font(.title2)
			.padding(.leading)
			.frame(width: 620, height: searchString.notEmpty ? 42 : 80) // Frame sem resultado de busca (original: 42H)
			
			if searchString.notEmpty {
				List {
					
					let titlesToShow = dataViewModel.getSpotlightListTitles(for: searchString)
					
					ForEach(titlesToShow, id:\.self) { section in
						
						Text("\(section)")
							.font(.headline)
							.bold()
							.foregroundStyle(.secondary)
						
						let listToShow = dataViewModel.getSpotlightList(for: section, using: searchString)
						
						if listToShow.isEmpty {
							Text("Sem resultados de \(section.lowercased()) para '\(searchString)'")
						} else {
							ForEach(listToShow, id:\.id) { entity in
								
								HStack {
									Image(systemName: section == "Processos" ? "handbag" : section == "Clientes" ? "person" : "doc")
									if let entity = entity as? LawsuitWrapper {
										VStack(alignment: .leading) {
											Text("\(entity.entityName)")
											Text("\(entity.lawsuit.number)")
												.font(.caption2)
										}
									} else {
										Text("\(entity.entityName)")
									}
									Spacer()
								}
								.font(.callout)
								.padding(.vertical, 5)
								.padding(.horizontal, 10)
								.onHover { hovering in
									currentEntity = hovering ? entity : nil
								}
								.onTapGesture {
									handleEntityTap(for: entity)
								}
								.background(
									currentEntity?.id == entity.id ? Color.secondary.opacity(0.3) : Color.clear
								)
								.clipShape(RoundedRectangle(cornerRadius: 8))
							}
						}
					}
					.listRowSeparator(.hidden)
                    .listRowBackground(VisualEffect().ignoresSafeArea())
					.listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
					
				}
				.scrollIndicators(.never)
				.scrollContentBackground(.hidden)
				.frame(height: 383) // Frame com resultado de busca
				
			}
			
		}
        .background(VisualEffect().ignoresSafeArea())
		
	}
}

#Preview {
	SpotlightSearchbarView()
}





extension String {
	
	var notEmpty: Bool {
		return !self.isEmpty
	}
}
