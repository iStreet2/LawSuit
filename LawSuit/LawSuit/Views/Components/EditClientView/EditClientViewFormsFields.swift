//
//  FormsFields.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI
import Combine

enum FormType {
    case personalInfo, address, contact, others
}

struct EditClientViewFormsFields: View {
    
    //MARK: ViewModels
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel

    //MARK: Variáveis de Estado
    
    let formType: FormType
    
    @ObservedObject var addressViewModel: AddressViewModel
    
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
    @State var isEmailValid = true
    
    let textLimit = 50
    let maritalStatusLimit = 10
    
    var body: some View {
        
        if formType == .personalInfo {
            HStack(alignment: .top) {
                VStack(spacing: 10) {
                    LabeledTextField(label: "RG", placeholder: "RG", textfieldText: $rg)
                        .onReceive(Just(rg)) { _ in rg = textFieldDataViewModel.formatNumber(rg, limit: 9) }
                    LabeledTextField(label: "Filiação", placeholder: "Filiação", textfieldText: $affiliation)
                        .onReceive(Just(affiliation)) { _ in textFieldDataViewModel.limitText(text: &affiliation, upper: textLimit) }
                    LabeledTextField(label: "Nacionalidade", placeholder: "Nacionalidade", textfieldText: $nationality)
                        .onReceive(Just(nationality)) { _ in textFieldDataViewModel.limitText(text: &nationality, upper: textLimit) }
                }
                VStack(spacing: 10) {
                    LabeledTextField(label: "CPF", placeholder: "CPF", textfieldText: $cpf)
                        .onReceive(Just(cpf)) { _ in cpf = textFieldDataViewModel.formatCPF(cpf) }
                        .foregroundStyle(textFieldDataViewModel.isValidCPF(cpf) ? .black : .red)
                    LabeledTextField(label: "Estado Civil", placeholder: "Estado Civil", textfieldText: $maritalStatus)
                        .onReceive(Just(maritalStatus)) { _ in textFieldDataViewModel.limitMaritalStatus(maritalStatus: &maritalStatus, upper: maritalStatusLimit) }
                }
            }
            
        } else if formType == .address {
            VStack(spacing: 10) {
                HStack(alignment: .top) {
                    LabeledTextField(label: "CEP", placeholder: "CEP", textfieldText: $cep)
                        .onReceive(Just(cep)) { _ in cep = textFieldDataViewModel.formatNumber(cep, limit: 8) }
                        .onChange(of: cep, perform: { _ in
                            Task{
                                if cep.count >= 8{
                                    if let addressApi = await addressViewModel.fetch(for: cep) {
                                        cep = addressApi.cep
                                        address = addressApi.logradouro
                                        neighborhood = addressApi.bairro
                                        state = addressApi.estado
                                        city = addressApi.localidade
                                    }
                                }
                            }
                        })
                    LabeledTextField(label: "Endereço", placeholder: "Endereço", textfieldText: $address)
                        .onReceive(Just(address)) { _ in textFieldDataViewModel.limitText(text: &address, upper: textLimit) }
                }
                HStack(alignment: .top) {
                    LabeledTextField(label: "Número", placeholder: "Número", textfieldText: $addressNumber)
                        .onReceive(Just(addressNumber)) { _ in addressNumber = textFieldDataViewModel.formatNumber(addressNumber, limit: 7) }
                    LabeledTextField(label: "Bairro", placeholder: "Bairro", textfieldText: $neighborhood)
                        .onReceive(Just(neighborhood)) { _ in textFieldDataViewModel.limitText(text: &neighborhood, upper: textLimit) }
                    LabeledTextField(label: "Complemento", placeholder: "Complemento", textfieldText: $complement)
                }
                HStack(alignment: .top) {
                    LabeledTextField(label: "Estado", placeholder: "Insira seu estado", textfieldText: $state)
                    LabeledTextField(label: "Cidade", placeholder: "Insira sua cidade", textfieldText: $city)
                }
            }
            
        } else if formType == .contact {
            VStack(spacing: 10) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("E-mail")
                        .bold()
                        .font(.body)
                        .foregroundStyle(Color.black)
                    TextField("Insira o e-mail do Cliente", text: $email)
                        .font(.body)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: email) { newValue in
                            isEmailValid = textFieldDataViewModel.isValidEmail(newValue)
                        }
                        .foregroundColor(isEmailValid ? .black : .red)
                }
                    if !isEmailValid {
                        HStack {
                            Text("E-mail inválido")
                                .foregroundStyle(.red)
                                .font(.caption)
                                .padding(.vertical, -5)
                                .padding(.horizontal, 10)
                            Spacer()
                        }
                    }
                HStack {
                    LabeledTextField(label: "Telefone", placeholder: "Telefone", textfieldText: $telephone)
                        .onReceive(Just(telephone)) { _ in telephone = textFieldDataViewModel.formatPhoneNumber(telephone, cellphone: false) }
                    LabeledTextField(label: "Celular", placeholder: "Celular", textfieldText: $cellphone)
                        .onReceive(Just(cellphone)) { _ in cellphone = textFieldDataViewModel.formatPhoneNumber(cellphone, cellphone: true) }
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
