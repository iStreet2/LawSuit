//
//  ContactsManager.swift
//  LawSuit
//
//  Created by Giovanna Micher on 15/10/24.
//

import Foundation
import Contacts
import SwiftUI

class ContactsManager {
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    func requestContactsAuthorization() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Erro ao solicitar acesso aos contatos: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }
            
            if granted {
                DispatchQueue.main.async {
                    print("acesso concedido")
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Permissão para acessar contatos foi negada. Vá até as Preferências do Sistema para permitir o acesso."
                    self.showAlert = true
                }
            }
        }
    }
    
    func createContact(name: String, cellphone: String, email: String/*, photo: Data*/, occupation: String) -> CNMutableContact {
        let contact = CNMutableContact()
        
        // Configura os dados do cliente
        contact.givenName = name
        contact.phoneNumbers = [CNLabeledValue(label: CNLabelPhoneNumberMobile, value: CNPhoneNumber(stringValue: cellphone))]
        contact.emailAddresses = [CNLabeledValue(label: CNLabelWork, value: email as NSString)]
        //contact.imageData = photo
        contact.jobTitle = occupation
        return contact
    }
    
//    func createCNMutableContact(client: Client) -> CNMutableContact {
//        
//    }
    
    //Quando clicar no botao de adicionar contato
    func checkContactsAuthorizationAndSave(contact: CNMutableContact) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        
        switch authorizationStatus {
        case .notDetermined:
            //Se a permissão não foi determinada, solicita o acesso
            requestContactsAuthorization()
            print("Pediu o acesso novamente")
        case .authorized:
            //Se já foi autorizado, adiciona o contato
            print("Autorizado")
            saveContact(contact: contact)
        case .denied:
            //Se o acesso foi negado, sugere ir para os ajustes
            alertMessage = "Acesso aos contatos foi negado. Vá até as Preferências do Sistema > Segurança e Privacidade para conceder acesso ao app."
            showAlert = true
        case .restricted:
            alertMessage = "O acesso aos contatos está restrito e não pode ser autorizado."
            showAlert = true
        @unknown default:
            alertMessage = "Erro desconhecido ao acessar contatos."
            showAlert = true
        }
    }
    
    func saveContact(contact: CNMutableContact) {
        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier: nil)
        
        do {
            try store.execute(saveRequest)
            print("salvo com sucesso")
        } catch {
            print("Erro ao salvar o contato: \(error.localizedDescription)")
            // Handle error
        }
    }
    
    func updateContact(contact: CNMutableContact) {
        guard let mutableContact = contact.mutableCopy() as? CNMutableContact else { return }
    }
    
//    func fetchContactBy(name: String) {
//        // limit the contact properties to fetch
//        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey] as [CNKeyDescriptor]
//        
//        let store = CNContactStore()
//        do {
//            let predicate = CNContact.predicateForContacts(matchingName: name)
//            let contacts = try store.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
//            print("Fetched contacts: \(contacts)")
//        } catch {
//            print("Failed to fetch contact, error: \(error)")
//            // Handle error
//        }
//    }
    
}

