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
    @State var states = ["São Paulo", "Rio de Janeiro", "Mato Grosso do Sul", "Minas Gerais", "Rio Grande do Sul", "Acre", "Ceará"]
    @State var cities = ["São Paulo", "Mogi das Cruzes", "Maringá", "Iaras", "Osasco", "Carapicuíba", "Barueri"]
    
    @Binding var name: String
    @Binding var occupation: String
    @Binding var rg: String
    @Binding var cpf: String
    @Binding var affiliation: String
    @Binding var maritalStatus: String
    @Binding var nationality: String
    @Binding var birthDate: Date
    @Binding var cep: String
    @Binding var address: String
    @Binding var addressNumber: String
    @Binding var neighborhood: String
    @Binding var complement: String
    @Binding var state: String
    @Binding var city: String
    @Binding var email: String
    @Binding var telephone: String
    @Binding var cellphone: String
    
    var body: some View {
        // if stage == 1
        if stage == 1 {
            HStack {
                VStack(spacing: 15) {
                    LabeledTextField(label: "Nome Completo", placeholder: "Insira seu nome", textfieldText: $name)
                    LabeledTextField(label: "RG", placeholder: "RG", textfieldText: $rg)
                    LabeledTextField(label: "Filiação", placeholder: "Filiação", textfieldText: $affiliation)
                    LabeledTextField(label: "Nacionalidade", placeholder: "Nacionalidade", textfieldText: $nationality)
                }
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "Profissão", placeholder: "Insira sua Profissão", textfieldText: $occupation)
                    LabeledTextField(label: "CPF", placeholder: "CPF", textfieldText: $cpf)
                    LabeledTextField(label: "Estado Civil", placeholder: "Estado Civil", textfieldText: $maritalStatus)
                    LabeledDateField(selectedDate: $birthDate, label: "Data de nascimento")
                }
            }
            .padding(.vertical, 5)
        } else if stage == 2 {
            VStack(alignment: .leading, spacing: 15) {
                LabeledTextField(label: "CEP", placeholder: "Insira seu CEP", textfieldText: $cep)
                LabeledTextField(label: "Endereço", placeholder: "Insira seu endereço", textfieldText: $address)
                HStack(spacing: 10) {
                    LabeledTextField(label: "Número", placeholder: "Insira o número", textfieldText: $addressNumber)
                        .frame(width: 120)
                    LabeledTextField(label: "Bairro", placeholder: "Insira seu bairro", textfieldText: $neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Insira o complemento", textfieldText: $complement)
                        .frame(width: 170)
                }
                HStack(spacing: 20) {
                    LabeledPickerField(selectedOption: $state, arrayInfo: states, label: "Estado")
                    Spacer()
                    LabeledPickerField(selectedOption: $city, arrayInfo: cities, label: "Cidade")
                }
                .frame(width: 250)
            }
            .padding(.vertical, 5)
        } else if stage == 3 {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "E-mail", placeholder: "Insira seu e-mail", textfieldText: $email)
                    HStack(spacing: 60) {
                        LabeledTextField(label: "Telefone", placeholder: "Insira seu telefone", textfieldText: $telephone)
                        LabeledTextField(label: "Celular", placeholder: "Insira seu celular", textfieldText: $cellphone)
                    }
                }
            }
            Spacer()
            .padding(.vertical, -5)
        }
    }
}
