//
//  ContactsManager.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 03/09/24.
//

import Foundation
import Contacts

class ContactsManager {

	func saveContact(contact: CNMutableContact) {
		
		let store = CNContactStore()
		let saveRequest = CNSaveRequest()
		saveRequest.add(contact, toContainerWithIdentifier: nil)
		
		do {
			try store.execute(saveRequest)
		} catch {
			print("Saving contact failed, error: \(error)")
			// Handle error
		}
	}
	
	func fetchContactBy(name: String) {
		// limit the contact properties to fetch
		let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
		
		let store = CNContactStore()
		do {
			let predicate = CNContact.predicateForContacts(matchingName: name)
			let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
			print("Fetched contacts: \(contacts)")
		} catch {
			print("Failed to fetch contact, error: \(error)")
			// Handle error
		}
	}
	
	func updateContact(contact: CNMutableContact) {
		guard let mutableContact = contact.mutableCopy() as? CNMutableContact else { return }
		
	}
}
