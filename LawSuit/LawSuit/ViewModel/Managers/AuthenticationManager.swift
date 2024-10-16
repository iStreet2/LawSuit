//
//  AuthenticationManager.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation
import AuthenticationServices

class AuthenticationManager: ObservableObject {
    
    // TODO: Talvez seja necessário declarar um modelo novo para salvar o email do mano após ele se autenticar rs
	
	func handleSuccessfulLogin(with authentication: ASAuthorization) {
		if let userCredential = authentication.credential as? ASAuthorizationAppleIDCredential {
			print(userCredential.user)
			
			if userCredential.authorizedScopes.contains(.fullName) {
				print(userCredential.fullName)
			}
			
			if userCredential.authorizedScopes.contains(.email) {
				print(userCredential.email)
			}
		}
	}
	
	func handleLoginError(with error: Error) {
		print("Error during sign-up: \(error)")
	}
	
	
}
