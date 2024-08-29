//
//  AddClientType.swift
//  LawSuit
//
//  Created by André Enes Pecci on 27/08/24.
//

import SwiftUI

enum ClientType {
    case personalInfo, address, contact, others
}

struct AddClientForm: View {
    
    @Binding var stage: Int
    @Binding var clientMock: ClientMock
    //    @State var clientType: ClientType
    //Cria um binding chamado stage
    @State var states = ["São Paulo", "Rio de Janeiro", "Mato Grosso do Sul", "Minas Gerais", "Rio Grande do Sul", "Acre", "Ceará"]
    @State var cities = ["São Paulo", "Mogi das Cruzes", "Maringá", "Iaras", "Osasco", "Carapicuíba", "Barueri"]
    
    var body: some View {
        //if stage == 1
        if stage == 1 {
            HStack {
                VStack(spacing: 15) {
                    LabeledTextField(label: "Nome Completo", placeholder: "Insira seu nome", textfieldText: $clientMock.name)
                    LabeledTextField(label: "RG", placeholder: "RG", textfieldText: $clientMock.rg)
                    LabeledTextField(label: "Filiação", placeholder: "Filiação", textfieldText: $clientMock.affiliation)
                    LabeledTextField(label: "Nacionalidade", placeholder: "Nacionalidade", textfieldText: $clientMock.nationality)
                }
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "Profissão", placeholder: "Insira sua Profissão", textfieldText: $clientMock.occupation)
                    LabeledTextField(label: "CPF", placeholder: "CPF", textfieldText: $clientMock.cpf)
                    LabeledTextField(label: "Estado Civil", placeholder: "Estado Civil", textfieldText: $clientMock.maritalStatus)
                    LabeledDateField(selectedDate: $clientMock.birthDate, label: "Data de nascimento")
                }
            }
//            Spacer()
                .padding(.vertical, 5)
            //else if stage == 2
        } else if stage == 2 {
            VStack(alignment: .leading ,spacing: 15) {
                LabeledTextField(label: "CEP", placeholder: "Insira seu CEP", textfieldText: $clientMock.cep)
                LabeledTextField(label: "Endereço", placeholder: "Insira seu endereço", textfieldText: $clientMock.address)
                HStack(spacing: 10) {
                    LabeledTextField(label: "Número", placeholder: "Insira o número", textfieldText: $clientMock.addressNumber)
                        .frame(width: 120)
                    LabeledTextField(label: "Bairro", placeholder: "Insira seu bairro", textfieldText: $clientMock.neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Insira o complemento", textfieldText: $clientMock.complement)
                        .frame(width: 170)
                }
                HStack(spacing: 20) {
                    LabeledPickerField(selectedOption: $clientMock.state, arrayInfo: states, label: "Estado")
                    Spacer()
                    LabeledPickerField(selectedOption: $clientMock.city, arrayInfo: cities, label: "Cidade")
                }
                .frame(width: 250)
            }
//            Spacer()
            .padding(.vertical, 5)
        }
        
        else if stage == 3 {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "E-mail", placeholder: "Insira seu e-mail", textfieldText: $clientMock.email)
                    HStack(spacing: 60) {
                        LabeledTextField(label: "Telefone", placeholder: "Insira seu telefone", textfieldText: $clientMock.telephone)
                        LabeledTextField(label: "Celular", placeholder: "Insira seu celular", textfieldText: $clientMock.cellphone)
                    }
                }
            }
            Spacer()
                .padding(.vertical, -5)
        }
    }
}

#Preview {
    @State var clientMock = ClientMock(name: "", occupation: "", rg: "", cpf: "", affiliation: "", maritalStatus: "", nationality: "", birthDate: Date(), cep: "", address: "", addressNumber: "", neighborhood: "", complement: "", state: "", city: "", email: "", telephone: "", cellphone: "")
    return AddClientForm(stage: .constant(3), clientMock: $clientMock)
}
