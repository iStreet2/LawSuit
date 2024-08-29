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

struct FormsFields: View {
    @Binding var clientMock: ClientMock
    @State var formType: FormType
    @State var states = ["São Paulo", "Rio de Janeiro", "Mato Grosso do Sul", "Minas Gerais", "Rio Grande do Sul", "Acre", "Ceará"]
    @State var cities = ["São Paulo", "Mogi das Cruzes", "Maringá", "Iaras", "Osasco", "Carapicuíba", "Barueri"]
    
    
    init(formType: FormType = .personalInfo, client: Binding<ClientMock>) {
        self.formType = formType
        self._clientMock = client
    }
    
    var body: some View {
        
        if formType == .personalInfo {
            HStack(alignment: .top) {
                VStack(spacing: 10) {
                    LabeledTextField(label: "RG", placeholder: "RG", textfieldText: $clientMock.rg)
                    LabeledTextField(label: "Filiação", placeholder: "Filiação", textfieldText: $clientMock.affiliation)
                    LabeledTextField(label: "Nacionalidade", placeholder: "Nacionalidade", textfieldText: $clientMock.nationality)
                }
                VStack(spacing: 10) {
                    LabeledTextField(label: "CPF", placeholder: "CPF", textfieldText: $clientMock.cpf)
                    LabeledTextField(label: "Estado Civil", placeholder: "Estado Civil", textfieldText: $clientMock.maritalStatus)
                }
            }
            .padding(.vertical, 5)
            
        } else if formType == .address {
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    LabeledTextField(label: "CEP", placeholder: "CEP", textfieldText: $clientMock.cep)
                    LabeledTextField(label: "Endereço", placeholder: "Endereço", textfieldText: $clientMock.address)
                }
                HStack(alignment: .top) {
                    LabeledTextField(label: "Número", placeholder: "Número", textfieldText: $clientMock.addressNumber)
                    LabeledTextField(label: "Bairro", placeholder: "Bairro", textfieldText: $clientMock.neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Complemento", textfieldText: $clientMock.complement)
                }
                HStack(alignment: .top) {
                    LabeledPickerField(selectedOption: $clientMock.state, arrayInfo: states, label: "Estado")
                    LabeledPickerField(selectedOption: $clientMock.city, arrayInfo: cities, label: "Cidade")
                }
            }
  
        }

    }
}

#Preview {
	@State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn", age: 30)
    return FormsFields(formType: .personalInfo, client: $clientMock)
}
