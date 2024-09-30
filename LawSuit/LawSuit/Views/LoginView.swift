//
//  LoginView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 25/09/24.
//

import Foundation
import SwiftUI
import AuthenticationServices


struct LoginView: View {
	
	@EnvironmentObject var dataViewModel: DataViewModel
	
	@State private var navigationPath = NavigationPath()
	
	@State var pathProgress = 0.0
	@State var transitionProgress = 0.0
	
	@State var authenticationViewIsPresented: Bool = true
	@State var userHasAUsername: Bool = false
	
	@State var office: Office? = nil
	
	var body: some View {
		NavigationStack(path: $navigationPath) {
			
			ZStack {
				
				
				if let result = dataViewModel.authenticationManager.userIsFirstTimeLoggingIn() {
					if result == true && userHasAUsername == false {  // Primeira vez loggando no app
						CreateAccountView(authenticationViewIsPresented: $authenticationViewIsPresented, userHasAUsername: $userHasAUsername) // atribui nome ao usuário
					}
					
					else {  // Usuário já está loggado no app
						
						if !dataViewModel.userDidJoinOffice() {
							// MARK: Se o usuário não fizer parte de nenhum escritório:
							CreateOrJoinOfficeView(authenticationViewIsPresented: $authenticationViewIsPresented)
							// cria o office e atribui o officeID ao usuário.officeID
						} else {
							
							// TODO: Se fizer
							// MARK: ContentView(office) ?????? -> Ir para o APP normal
							ContentView()
								.onAppear {
									Task {
										self.office = await dataViewModel.getUserOffice()
									}
								}
						}
					}
					
				}
				else {  // Usuário não foi criado -> não deve entrar nisso nunca
					
				}
					
				SignInWithAppleAuthenticationView(authenticationViewIsPresented: $authenticationViewIsPresented) // cria o usuário caso ele não exista
					.scaleEffect(1 + transitionProgress)
					.opacity(1 - (2 * transitionProgress))
				
			}
			
			.onChange(of: authenticationViewIsPresented) { newValue in
				
				if newValue == true {
					withAnimation(.easeOut(duration: 3)) {
						transitionProgress = 0
					}
				} else {
					withAnimation(.bouncy(duration: 3)) {
						transitionProgress = 1
					}
				}
			}
			
		}
//		.frame(maxWidth: 611, maxHeight: 400)
	}
	
}

#Preview {
	LoginView()
		.environmentObject(DataViewModel())
}


struct CheckShape: Shape {
	func path(in rect: CGRect) -> Path {
		Path { path in
			path.move(to: rect.origin)
			
			path.addLine(to: CGPoint(x: rect.origin.x + 20, y: rect.origin.y + 20))
			path.addLine(to: CGPoint(x: rect.origin.x + 50, y: rect.origin.y - 10))
		}
	}
}
