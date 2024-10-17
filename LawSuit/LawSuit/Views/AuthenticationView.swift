//
//  AuthenticationView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 10/10/24.
//

import SwiftUI
import AuthenticationServices

struct AuthenticationView: View {
	
	@EnvironmentObject var dataViewModel: DataViewModel
	
	@Binding var authenticationStatus: Bool
	@State var authenticationDidFail: Bool = false
	
	@State var animationProgress = 0
	
	var body: some View {
		ZStack {
			
			Color.white
			
			Image("ArqionBackgroundPattern")
				.resizable(resizingMode: .tile)
				.opacity(0.4)
			
			VStack {
				Image("ArqionLogo")
					.resizable()
					.scaledToFit()
					.frame(width: 260, height: 100)
				
				SignInWithAppleButton(.signIn) { request in
					request.requestedScopes = [.fullName, .email]
				} onCompletion: { result in
					switch result {
					case .success(let authorization):
						dataViewModel.handleSuccessfulLogin(with: authorization)
                        withAnimation(.easeInOut(duration: 0.5)) {
							authenticationStatus = true
						}
					case .failure(let error):
						dataViewModel.handleLoginError(with: error)
						authenticationStatus = false
						authenticationDidFail = true
					}
				}
				.frame(width: 300)
				
				if authenticationDidFail {
					Text("Houve um erro no sign in, tente novamente")
						.foregroundStyle(.red)
						.font(.callout)
				}
			}
			
		}
	}
}

#Preview {
	AuthenticationView(authenticationStatus: .constant(false))
		.environmentObject(DataViewModel())
}
