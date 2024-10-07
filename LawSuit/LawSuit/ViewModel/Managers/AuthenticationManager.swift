//
//  AuthenticationManager.swift
//  LawSuit
//
//  Created by Giovanna Micher on 12/09/24.
//

import Foundation
import CoreData
import AuthenticationServices

class AuthenticationManager: ObservableObject {
	
	@Published var userShouldAuthenticate: Bool = false
	@Published var authenticationStatus: Bool? = nil
	
	var context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
		
		let request = NSFetchRequest<Lawyer>(entityName: "Lawyer")
		
	}
	
	
	func handleSuccessfullLogin(with authorization: ASAuthorization) -> Lawyer? {
		
		if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			
			let email = userCredential.email
			let name = userCredential.fullName
			
			if self.fetchUser() == nil {
				if let email = email {
					if let givenName = name?.givenName,
						let familyName = name?.familyName {
						return createUser(with: email, name: "\(givenName) \(familyName)")
					} else {
						return createUser(with: email)
					}
				} else {
					print("O email não foi retornado. Pode ter sido um login repetido.")
				}
			}
			
			self.userShouldAuthenticate = false
		}
		authenticationStatus = true
		return nil
	}
	
	func createUser(with email: String, name: String = "") -> Lawyer? {
		let user = Lawyer(context: self.context)
		user.email = email
		user.name = name
		
		do {
			try context.save()
			print("AuthenticationManager.createUser() -> Contexto salvo com sucesso")
			return user
		} catch {
			print("AuthenticationManager.createUser() -> Could not save context: \(error)")
		}
		return nil
	}
	
	
	func handleLoginError(with error: Error) {
		print("Could not authenticate: \(error)")
		
		authenticationStatus = false
	}
	
	
	func fetchUser() -> Lawyer? {
		let request = NSFetchRequest<Lawyer>(entityName: "Lawyer")
		
		do {
			let result = try context.fetch(request)
			
			if result.isEmpty {
				return nil
			}
			return result[0]
			
		} catch {
			print("Error fetching user: \(error)")
		}
		
		return nil
	}
	
}
