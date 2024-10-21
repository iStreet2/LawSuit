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
	var context: NSManagedObjectContext
	
	init(context: NSManagedObjectContext) {
		self.context = context
	}
	
	func handleSuccessfulLogin(with authentication: ASAuthorization) {
		if let userCredential = authentication.credential as? ASAuthorizationAppleIDCredential {
			print(userCredential.user)
			
			if userCredential.authorizedScopes.contains(.fullName) {
				print(userCredential.fullName)
			}
			
			if userCredential.authorizedScopes.contains(.email) {
				print(userCredential.email)
			}
			
			checkForUserCreation(email: userCredential.email ?? "EMAIL NOT PASSED", fullName: userCredential.fullName?.namePrefix ?? "FULL NAME NOT PASSED" , userKey: userCredential.user)
		}
	}
	
	func handleLoginError(with error: Error) {
		print("Error during sign-up: \(error)")
	}
	
	func checkForUserCreation(email: String, fullName: String, userKey: String) {
		let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
		
		do {
			let result = try context.fetch(userFetchRequest)
			
			if result.isEmpty {
				createUser(email: email, fullName: fullName, userKey: userKey)
			}
		} catch {
			print("Error fetching users: \(error)")
		}
	}
	
	func createUser(email: String, fullName: String, userKey: String) {
		let user = User(context: context)
		user.email = email
		user.fullName = fullName
		user.userKey = userKey
		
		do {
			try context.save()
		} catch {
			print("Error saving user: \(error)")
		}
	}
	
	func checkAccountStatus() -> Bool {
		let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
		
		do {
			let result = try context.fetch(userFetchRequest)
			
			guard let user = result.first else { return false }
			
			if user.userName != nil {
				return true
			}
			return false
			
		} catch {
			print("Error fetching users: \(error)")
		}
		
		return false
	}
	
	func deleteUserAccount() {
		let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
		
		do {
			let result = try context.fetch(userFetchRequest)
			
			guard let user = result.first else { return }
			
			user.userName = nil
			user.photo = nil
			
			try context.save()
			
		} catch {
			print("Error fetching users: \(error)")
		}
	}
	
	func printUsers() {
		let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
		
		do {
			let result = try context.fetch(userFetchRequest)
			
			for user in result {
				print("User: \(user.fullName)")
			}
		} catch {
			print("Error fetching users: \(error)")
		}
	}
}
