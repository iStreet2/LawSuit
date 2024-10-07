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
	
//	@State var currentPresentedView: screenStates = .loginView
	
	var body: some View {
		NavigationStack(path: $navigationPath) {
			
			if let user = dataViewModel.user {
				Text("\(user.name)")
				Text("\(user.username)")
				Text("\(user.email)")
				Text("\(user.officeID)")
			}
			
			ZStack {
				
				if !userHasAUsername && dataViewModel.user?.username == nil { // usuário ainda não possui username
					CreateAccountView(authenticationViewIsPresented: $authenticationViewIsPresented, userHasAUsername: $userHasAUsername)
				} else { // usuário possui username / já criou sua conta
					
					if dataViewModel.user?.officeID == nil { // usuário não está em nenhum escritório
						CreateOrJoinOfficeView(authenticationViewIsPresented: $authenticationViewIsPresented)
					} else { // está em um escritório
						if let office = office {
							ContentView(office: office)
						}
					}
					
				}
				
				SignInWithAppleAuthenticationView(authenticationViewIsPresented: $authenticationViewIsPresented) // cria o usuário caso ele não exista
					.opacity(1 - (transitionProgress))
					.onAppear {
						Task {
							self.office = await dataViewModel.getUserOffice()
						}
					}
				
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

enum screenStates {
	case loginView
	case creatingProfileView
	case createOrJoinOfficeView
	case createOfficeView
}

extension LoginView {
	private var loginViewBackground: some View {
		Image("Login_Background")
			.resizable()
	}
	
	private var creatingProfileView: some View {
		Image("Login_Background")
			.resizable()
	}
}
