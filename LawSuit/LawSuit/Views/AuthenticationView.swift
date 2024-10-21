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
	
	@State var animationProgress: CGFloat = 0
	@Binding var transitionProgress: Double
	
	var body: some View {
		ZStack {
//			Color.white
//			
//			Image("ArqionBackgroundPattern")
//				.resizable(resizingMode: .tile)
//				.opacity(0.4)
			
			VStack {
				Image("ArqionLogo")
					.resizable()
					.scaledToFit()
					.frame(width: 260, height: 100)
					.scaleEffect(authenticationStatus == true ? 120 : 1, anchor: .init(x: 0.44, y: 0.5))
					.opacity(transitionProgress == 0 ? 1 : 0)
				
				SignInWithAppleButton(.signIn) { request in
					request.requestedScopes = [.fullName, .email]
				} onCompletion: { result in
					switch result {
					case .success(let authorization):
						dataViewModel.handleSuccessfulLogin(with: authorization)

						withAnimation(.easeIn(duration: 2)) {
							animationProgress = NSScreen.main?.visibleFrame.height ?? 1000
						}
						
						DispatchQueue.main.asyncAfter(deadline: .now()+1) {
							withAnimation(.easeInOut(duration: 3)) {
								authenticationStatus = true
								transitionProgress = 1
							}
						}
						
					case .failure(let error):
						dataViewModel.handleLoginError(with: error)
						authenticationStatus = false
						authenticationDidFail = true
					}
				}
				.frame(width: 300)
				.offset(y: animationProgress)
				
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
	AuthenticationView(authenticationStatus: .constant(false), transitionProgress: .constant(0))
		.environmentObject(DataViewModel())
}
