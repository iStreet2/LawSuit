//
//  SignInWithAppleAuthenticationView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 26/09/24.
//

import SwiftUI
import AuthenticationServices


struct SignInWithAppleAuthenticationView: View {
	
	@EnvironmentObject var dataViewModel: DataViewModel
	@State var authenticationStatus: Bool? = nil
	
	@Binding var authenticationViewIsPresented: Bool
	
	var body: some View {
		ZStack {
			
			Color.white
			
			Image("Login_Background")
				.resizable()
			
			VStack {
				Image("Arqion_Logo")
					.resizable()
					.frame(width: 259, height: 102, alignment: .center)
					.padding()
				
				SignInWithAppleButton { request in
					request.requestedScopes = [.email, .fullName]
				} onCompletion: { result in
					switch result {
					case .success(let authorization):
						dataViewModel.authenticationManager.handleSuccessfullLogin(with: authorization)
						authenticationStatus = true
						
						authenticationViewIsPresented = false
						// MARK: IR PARA PRÓXIMA TELA
					case .failure(let error):
						dataViewModel.authenticationManager.handleLoginError(with: error)
						authenticationStatus = false
					}
				}
				.frame(width: 130) // MARK: FRAME OPCIONAL
				
				
				// MARK: - confirmação visual do sign in with apple dentro do APP
				//				CheckShape()
				//					.trim(from: 0.0, to: pathProgress)
				//					.stroke(Color.green, lineWidth: 5)
				//
				//				if let authStatus = authenticationStatus {
				//					if authStatus == true {
				//						Text("Autenticado com sucesso!")
				//							.foregroundStyle(.green)
				//
				//					} else {
				//						Text("Erro na autenticação")
				//							.foregroundStyle(.red)
				//					}
				//				}
				
			}
			.frame(width: 700, height: 600)
			.background(
				ZStack {
					Color.white
					Image("Login_Background")
						.resizable()
				}
			)
		}
		.ignoresSafeArea()
		.frame(maxWidth: .infinity, maxHeight: .infinity)
		
	}
}

#Preview {
	SignInWithAppleAuthenticationView(authenticationViewIsPresented: .constant(true))
}
