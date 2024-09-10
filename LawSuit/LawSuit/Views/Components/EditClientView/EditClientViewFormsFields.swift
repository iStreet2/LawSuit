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
    
    //MARK: ViewModels
    @EnvironmentObject var clientDataViewModel: TextFieldDataViewModel
    
    //MARK: Variáveis de Estado
    
    let formType: FormType
    
    @Binding var rg: String
    @Binding var affiliation: String
    @Binding var nationality: String
    @Binding var cpf: String
    @Binding var maritalStatus: String
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
    
    let states = ["São Paulo", "Rio de Janeiro", "Mato Grosso do Sul", "Minas Gerais", "Rio Grande do Sul", "Acre", "Ceará"]
    let cities = ["São Paulo", "Mogi das Cruzes", "Maringá", "Iaras", "Osasco", "Carapicuíba", "Barueri"]
    
    var body: some View {
        
        if formType == .personalInfo {
            HStack(alignment: .top) {
                VStack(spacing: 10) {
                    LabeledTextField(label: "RG", placeholder: "RG", textfieldText: $rg)
                    LabeledTextField(label: "Filiação", placeholder: "Filiação", textfieldText: $affiliation)
                    LabeledTextField(label: "Nacionalidade", placeholder: "Nacionalidade", textfieldText: $nationality)
                }
                VStack(spacing: 10) {
                    LabeledTextField(label: "CPF", placeholder: "CPF", textfieldText: $cpf)
                    LabeledTextField(label: "Estado Civil", placeholder: "Estado Civil", textfieldText: $maritalStatus)
                }
            }
            
        } else if formType == .address {
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    LabeledTextField(label: "CEP", placeholder: "CEP", textfieldText: $cep)
                    LabeledTextField(label: "Endereço", placeholder: "Endereço", textfieldText: $address)
                }
                HStack(alignment: .top) {
                    LabeledTextField(label: "Número", placeholder: "Número", textfieldText: $addressNumber)
                    LabeledTextField(label: "Bairro", placeholder: "Bairro", textfieldText: $neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Complemento", textfieldText: $complement)
                }
                HStack(alignment: .top) {
                    LabeledPickerField(selectedOption: $state, arrayInfo: states, label: "Estado")
                    LabeledPickerField(selectedOption: $city, arrayInfo: cities, label: "Cidade")
                }
            }
            
        } else if formType == .contact {
            VStack(spacing: 10) {
                LabeledTextField(label: "E-mail", placeholder: "E-mail", textfieldText: $email)
                HStack {
                    LabeledTextField(label: "Telefone", placeholder: "Telefone", textfieldText: $telephone)
                    LabeledTextField(label: "Celular", placeholder: "Celular", textfieldText: $cellphone)
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
