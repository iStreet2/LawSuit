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
	}
	
	
	func handleSuccessfullLogin(with authorization: ASAuthorization) {
		
		if let userCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
			
			let email = userCredential.email
			let name = userCredential.fullName
			
			if let email = email {
				if let givenName = name?.givenName,
					let familyName = name?.familyName {
					createUser(with: email, name: "\(givenName) \(familyName)")
				} else {
					createUser(with: email)
				}
			} else {
				print("O email não foi retornado. Pode ter sido um login repetido.")
			}
			
			self.userShouldAuthenticate = false
		}
		authenticationStatus = true
	}
	
	func createUser(with email: String, name: String = "") {
		if let result = self.userIsFirstTimeLoggingIn() {
			
			if result == true {
				let user = Lawyer(context: self.context)
				user.email = email
				user.name = name
				
				do {
					try context.save()
				} catch {
					print("Could not save context: \(error)")
				}
				
				return
			}
			print("User already exists!")
		}
	}
	
	func handleLoginError(with error: Error) {
		print("Could not authenticate: \(error)")
		
		authenticationStatus = false
	}
	
	func userIsFirstTimeLoggingIn() -> Bool? {
		let request = NSFetchRequest<Lawyer>(entityName: "Lawyer")
		
		do {
			let result = try context.fetch(request)
			
			if result.isEmpty {
				return true
			}
			else {
				if let username = result[0].username {
					return false
				} else {
					return true
				}
			}
			
		} catch {
			print("Error fetching user: \(error)")
		}
		
		return nil
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
	
	func getUserEmail() -> String? {
		if let user = fetchUser() {
			return user.email ?? "NIL EMAIL"
		}
		return nil
	}
	
	func getUserName() -> String? {
		if let user = fetchUser() {
			return user.name ?? "NIL NAME"
		}
		return nil
	}
	
	func getUserUsername() -> String? {
		if let user = fetchUser() {
			return user.username ?? "NIL USERNAME"
		}
		return nil
	}
	
	func setUserUsername(username: String) {
		if let user = self.fetchUser() {
			user.username = username
			
			do {
				try context.save()
			} catch {
				print("Error saving after username attribution: \(error)")
			}
		} else {
			print("Usuário não existe para ter um username atribuído!")
		}
	}
}
