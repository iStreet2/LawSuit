//
//  CreateOfficeView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 30/09/24.
//

import SwiftUI

struct CreateOfficeView: View {
	
	@Environment(\.dismiss) var dismiss
	
	@EnvironmentObject var dataViewModel: DataViewModel
	
	@State var officeName: String = ""
	
	var body: some View {
		VStack(alignment: .leading) {
			Text("Criar Escritório")
				.font(.largeTitle)
				.bold()
			
			Text("Nome")
				.bold()
			
			TextField("", text: $officeName, prompt: Text("Placeholder"))
			
			Text("Administrador")
				.foregroundStyle(.secondary)
				.bold()
			
			HStack {  // TODO: PEGAR IMAGEM E COLOCAR NO COREDATA
				// Imagem do mano
				Text(dataViewModel.authenticationManager.getUserName()!)
			}
			
			HStack {
				Button {
					dismiss()
				} label: {
					Text("Cancelar")
				}
				
				Button {
					// TODO: CRIAR O ESCRITÓRIO COM O NOME E O OWNER SENDO A PESSOA DO COREDATA
					Task {
						await dataViewModel.createOffice(
							name: officeName,
							lawyer: dataViewModel.authenticationManager.fetchUser()!
						)
					}
				} label: {
					Text("Criar")
				}
			}
			
		}
	}
}

#Preview {
	CreateOfficeView()
}
