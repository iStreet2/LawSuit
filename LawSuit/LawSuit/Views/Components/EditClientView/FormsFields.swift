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
//                    LabeledField(label: "CEP", placeholder: "Número do CEP")
//                    LabeledField(label: "Endereço", placeholder: "Endereço")
                }
                HStack(alignment: .top) {
//                    LabeledField(label: "Número", placeholder: "Número")
//                    LabeledField(label: "Bairro", placeholder: "Bairro")
//                    LabeledField(label: "Complemento", placeholder: "Complemento")
                }
                HStack(alignment: .top) {
//                    LabeledField(label: "Estado", placeholder: "", labeledFieldType: .picker, arrayInfo: states)
//                    LabeledField(label: "Cidade", placeholder: "", labeledFieldType: .picker, arrayInfo: cities)
                }
            }
  
        }

    }
}

#Preview {
    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
    return FormsFields(formType: .personalInfo, client: $clientMock)
}
