//
//  FormsFields.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

enum FormType {
    case personalInfo, address, contact, others
}

struct EditClientViewFormsFields: View {
    let formType: FormType
    @ObservedObject var client: Client
    
    let states = ["São Paulo", "Rio de Janeiro", "Mato Grosso do Sul", "Minas Gerais", "Rio Grande do Sul", "Acre", "Ceará"]
    let cities = ["São Paulo", "Mogi das Cruzes", "Maringá", "Iaras", "Osasco", "Carapicuíba", "Barueri"]

    
    var body: some View {
        
        if formType == .personalInfo {
            HStack(alignment: .top) {
                VStack(spacing: 10) {
                    LabeledTextField(label: "RG", placeholder: "RG", textfieldText: $client.rg)
                    LabeledTextField(label: "Filiação", placeholder: "Filiação", textfieldText: $client.affiliation)
                    LabeledTextField(label: "Nacionalidade", placeholder: "Nacionalidade", textfieldText: $client.nationality)
                }
                VStack(spacing: 10) {
                    LabeledTextField(label: "CPF", placeholder: "CPF", textfieldText: $client.cpf)
                    LabeledTextField(label: "Estado Civil", placeholder: "Estado Civil", textfieldText: $client.maritalStatus)
                }
            }
            
        } else if formType == .address {
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    LabeledTextField(label: "CEP", placeholder: "CEP", textfieldText: $client.cep)
                    LabeledTextField(label: "Endereço", placeholder: "Endereço", textfieldText: $client.address)
                }
                HStack(alignment: .top) {
                    LabeledTextField(label: "Número", placeholder: "Número", textfieldText: $client.addressNumber)
                    LabeledTextField(label: "Bairro", placeholder: "Bairro", textfieldText: $client.neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Complemento", textfieldText: $client.complement)
                }
                HStack(alignment: .top) {
                    LabeledPickerField(selectedOption: $client.state, arrayInfo: states, label: "Estado")
                    LabeledPickerField(selectedOption: $client.city, arrayInfo: cities, label: "Cidade")
                }
            }
            
            
        } else if formType == .contact {
            VStack(spacing: 10) {
                LabeledTextField(label: "E-mail", placeholder: "E-mail", textfieldText: $client.email)
                HStack {
                    LabeledTextField(label: "Telefone", placeholder: "Telefone", textfieldText: $client.telephone)
                    LabeledTextField(label: "Celular", placeholder: "Celular", textfieldText: $client.cellphone)
                }
            }
        } else {
            HStack {
                Text("Adicionar novo campo")
                Image(systemName: "plus")
            }
            .font(.title3)
            .foregroundStyle(Color(.gray))
        }
        
    }
}

//#Preview {
//    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
//    return EditClientViewFormsFields(formType: .personalInfo, client: $clientMock)
//}
