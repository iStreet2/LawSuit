//
//  CreateOrJoinOfficeView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 26/09/24.
//

import SwiftUI

struct CreateOrJoinOfficeView: View {
	
	@EnvironmentObject var dataViewModel: DataViewModel
	
	@State var didCopyEmail: Bool = false
	@Binding var authenticationViewIsPresented: Bool
	
	var body: some View {
		ZStack {
			VStack {
				
				header
				
				Spacer()
				
				VStack(alignment: .leading, spacing: 20) {
					
					Text("Olá, \(dataViewModel.user?.username ?? "")!")
						.font(.largeTitle)
						.bold()
					
					HStack {
						Text("Seu E-Mail")
							.font(.title3)
							.bold()
							.foregroundStyle(.secondary)
						
						Button {
							let pasteboard = NSPasteboard.general
							pasteboard.clearContents()
							pasteboard.setString(dataViewModel.user?.email ?? "", forType: .string)
							
							withAnimation(.bouncy(duration: 1)) {
								didCopyEmail = true
								
								DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
									withAnimation(.bouncy(duration: 1)) {
										didCopyEmail = false
									}
								}
							}
						} label: {
							HStack {
								Text(dataViewModel.user?.email ?? "")
								Image(systemName: didCopyEmail ? "checkmark.circle" : "rectangle.portrait.on.rectangle.portrait")
							}
							.font(.title3)
							
						}
						.buttonStyle(PlainButtonStyle())

					}
					
					Text("Entre em contato com o administrador de seu escritório e envie o e-mail acima para ingressar nele.")
					
					Text("Caso você seja o administrador, crie um escritório no botão localizado no canto superior direito.")
					
				}
				.frame(width: (NSScreen.main?.visibleFrame.width)! * 0.3)
				
				Spacer()
				
			}
		}
	}
	
}

#Preview {
	CreateOrJoinOfficeView(authenticationViewIsPresented: .constant(false))
}

extension CreateOrJoinOfficeView {
	
	private var header: some View {
		HStack {
			Button {
				authenticationViewIsPresented = true
			} label: {
				Text("Sair")
					.underline()
			}
			.buttonStyle(PlainButtonStyle())
			
			Spacer()
			
			NavigationLink {
				CreateOfficeView()
			} label: {
				HStack {
					Image(systemName: "plus")
						.foregroundStyle(.red, .red.opacity(0.5))
					
					Text("Criar Escritório")
						.font(.title3)
						.bold()
						.foregroundStyle(.red)
				}
			}
			.buttonStyle(PlainButtonStyle())
		}
	}
	
	
	
}
