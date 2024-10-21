//
//  UsernameView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/10/24.
//

import SwiftUI

struct UsernameView: View {
	
	@EnvironmentObject var dataViewModel: DataViewModel
	
	@State var username: String = ""
	@Binding var shouldGoToContentView: Bool
	
	@FetchRequest(sortDescriptors: []) var users: FetchedResults<User>
	
	var body: some View {
		GeometryReader { geometry in
			ZStack {
				Color.white
				
				VStack(alignment: .leading) {
					Spacer()
					
					Image("ArqionLogo")
						.resizable()
						.scaledToFill()
						.frame(width: 130, height: 50)
					
					Text("Criar Conta")
						.font(.largeTitle)
						.bold()
					
					HStack {
						RoundedRectangle(cornerRadius: 14)
							.frame(width: 82, height: 82)
						
						LabeledTextField(label: "Nome", placeholder: "Nome de Usuário", textfieldText: $username)
							.frame(maxWidth: 400)
					}
					
					Spacer()
					
					HStack {
						Spacer()
						
						Button {
							
						} label: {
							Text("Cancelar")
						}
						
						Button {
							if let user = users.first {
								user.userName = username
								
								do {
									try dataViewModel.context.save()
									shouldGoToContentView = true
								} catch {
									print("Could not save context after creating user: \(error)")
								}
							} else {
								print("No user created at this time.")
							}
						} label: {
							Text("Criar")
						}
					}
					.padding(.trailing, geometry.size.width / 2)
				}
			}
			.padding(.leading, 50)
		}
	}
}

#Preview {
	UsernameView(shouldGoToContentView: .constant(false))
}
