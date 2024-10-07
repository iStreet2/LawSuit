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
	
	@State var shouldAnimate: Bool = false
	
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
						dataViewModel.handleSuccessfullLogin(with: authorization)
						authenticationStatus = true
						
						authenticationViewIsPresented = false
						// MARK: IR PARA PRÓXIMA TELA
						
						withAnimation(.easeIn(duration: 1)) {
							shouldAnimate = true
						}
						
					case .failure(let error):
						dataViewModel.authenticationManager.handleLoginError(with: error)
						authenticationStatus = false
					}
				}
				.frame(width: 130) // MARK: FRAME OPCIONAL
				.offset(y: shouldAnimate ? (NSScreen.main?.visibleFrame.height)! + 100 : 0)
				.onChange(of: authenticationViewIsPresented) { newValue in
					if newValue {
						shouldAnimate = false
					} else {
						shouldAnimate = true
					}
				}
				
				
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
			.scaleEffect(1 + shouldAnimate.double)
			.opacity(1 - (2 * shouldAnimate.double))
//			.frame(width: 700, height: 600)
//			.background(
//				ZStack {
//					Color.white
//					Image("Login_Background")
//						.resizable()
//				}
//			)
		}
		.ignoresSafeArea()
//		.frame(maxWidth: .infinity, maxHeight: .infinity)
		
	}
}

#Preview {
	SignInWithAppleAuthenticationView(authenticationViewIsPresented: .constant(true))
}

extension Bool {
	var int: Int {
		if self {
			return 1
		}
		return 0
	}
	
	var double: Double {
		if self {
			return 1.0
		}
		return 0.0
	}
}
