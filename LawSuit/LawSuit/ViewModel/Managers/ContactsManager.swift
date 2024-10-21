//
//  ContactsManager.swift
//  LawSuit
//
//  Created by Giovanna Micher on 15/10/24.
//

import Foundation
import Contacts
import SwiftUI

enum AlertMessageEnum: String {
    case accessDenied = "Acesso aos contatos foi negado. Vá até as Preferências do Sistema > Segurança e Privacidade para conceder acesso ao app."
    case accessRestricted = "O acesso aos contatos está restrito e não pode ser autorizado."
    case unknownError = "Erro desconhecido ao acessar contatos."
}

class ContactsManager: ObservableObject {
    let store = CNContactStore()
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    func requestContactsAuthorization() {
        store.requestAccess(for: .contacts) { granted, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    print("Erro ao solicitar acesso aos contatos: \(error.localizedDescription)")
                }
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    print("acesso concedido")
                }
            }
        }
    }
    
    func updateClientContact(client: Client, oldClientEmail: String) throws {
        let predicate = CNContact.predicateForContacts(matchingEmailAddress: oldClientEmail)
        let keysToFetch = [CNContactGivenNameKey, CNContactImageDataKey, CNContactPhoneNumbersKey, CNContactEmailAddressesKey, CNContactJobTitleKey] as [CNKeyDescriptor]
        
        let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
        
        guard let contact = contacts.first else {
            throw NSError(domain: "Contact not found", code: 404, userInfo: nil)
        }
                
        let mutableContact = contact.mutableCopy() as! CNMutableContact
        
        mutableContact.givenName = client.name
        mutableContact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMain, value: CNPhoneNumber(stringValue: client.cellphone))]
        mutableContact.emailAddresses = [CNLabeledValue(label: CNLabelHome, value: client.email as NSString)]
        mutableContact.imageData = client.photo
        mutableContact.jobTitle = client.occupation
        
        let saveRequest = CNSaveRequest()
        saveRequest.update(mutableContact)
        try store.execute(saveRequest)
    }
    
    func createContact(name: String, cellphone: String, email: String, photo: Data, occupation: String) -> CNMutableContact {
        let contact = CNMutableContact()
        
        // Configura os dados do cliente
        contact.givenName = name
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: cellphone))]
        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: email as NSString)]
        contact.imageData = photo
        contact.jobTitle = occupation
        return contact
    }
    
    //Quando clicar no botao de adicionar contato
    func checkContactsAuthorizationAndSave(contact: CNMutableContact) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
            
        case .notDetermined:
            requestContactsAuthorization()
            print("Pediu o acesso novamente")
        case .authorized:
            print("Autorizado")
            saveContact(contact: contact)
        case .denied:
            alertMessage = AlertMessageEnum.accessDenied.rawValue
            showAlert = true
        case .restricted:
            alertMessage = AlertMessageEnum.accessRestricted.rawValue
            showAlert = true
        @unknown default:
            alertMessage = AlertMessageEnum.unknownError.rawValue
            showAlert = true
        }
    }
    
    func saveContact(contact: CNMutableContact) {
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
            print("salvo com sucesso")
        } catch {
            print("Erro ao salvar o contato: \(error.localizedDescription)")
        }
    }
    
}
