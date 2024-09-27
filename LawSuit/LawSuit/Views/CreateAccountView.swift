//
//  CreateAccountView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 26/09/24.
//

import Foundation
import SwiftUI

struct CreateAccountView: View {
	
	@EnvironmentObject var dataViewModel: DataViewModel
	
	@State var nameValue: String = ""
	@State var seeYouNextTimeIsPresented: Bool = false
	
	@Binding var authenticationViewIsPresented: Bool
	
	var body: some View {
		ZStack {
			
			Color.white
			
			HStack {
				Image("Login_Background")
					.resizable()
					.frame(width: 200)
				
				Color.white
					.frame(width: .infinity, height: .infinity)
			}
			
			HStack {
				
				VStack {
					Spacer()
					
					Image("Arqion_Logo")
						.resizable()
						.frame(width: 130, height: 51)
					
					VStack(alignment: .leading) {
						Text("Criar Conta")
							.font(.largeTitle)
							.bold()
						
						HStack {
							
							Button {
								
							} label: {
								
								Image(systemName: "photo.badge.plus")
									.resizable()
									.scaledToFill()
									.frame(width: 28, height: 32)
									.padding()
									.background(
										RoundedRectangle(cornerRadius: 14)
											.stroke(Color.red.opacity(0.5), lineWidth: 1)
									)
								
							}
							.buttonStyle(PlainButtonStyle())
							
							VStack(alignment: .leading) {
								Text("Nome")
									.bold()
								
								TextField("", text: $nameValue, prompt: Text("Placeholder"))
									.textFieldStyle(.plain)
									.padding()
									.background(
										RoundedRectangle(cornerRadius: 5)
											.stroke(Color.red.opacity(0.5), lineWidth: 1)
									)
								
							}
						}
						
						HStack {
							Spacer()
							
							Button {
								authenticationViewIsPresented = true
								
								withAnimation(.easeIn(duration: 1)) {
									seeYouNextTimeIsPresented = true
								}
								
								DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
									seeYouNextTimeIsPresented = false
								}
								
							} label: {
								Text("Cancelar")
							}
							
							Button {
								dataViewModel.authenticationManager.setUserUsername(username: nameValue)
							} label: {
								Text("Criar")
							}
							.buttonStyle(.borderedProminent)
							.foregroundStyle(.gray)
						}
						.padding()
						
					}
					
					Spacer()
				}
			}
			.background(
				Color.white
			)
			
			if seeYouNextTimeIsPresented {
				Text("See you next time!")
					.font(.largeTitle)
					.frame(width: NSScreen.main?.visibleFrame.width, height: NSScreen.main?.visibleFrame.height, alignment: .center)
					.background(VisualEffect())
			}
		}
	}
}
