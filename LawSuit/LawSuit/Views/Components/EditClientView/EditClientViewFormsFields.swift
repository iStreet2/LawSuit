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
    @Binding var socialName: String
    @Binding var affiliation: String
    @Binding var nationality: String
    @Binding var cpf: String
    @Binding var maritalStatus: String
    @Binding var Occupation: String
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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    LabeledTextField(label: "Nome Social", placeholder: "Insira o Nome Social do Cliente", textfieldText: $socialName)
                        .onReceive(Just(socialName)) { _ in textFieldDataViewModel.limitText(text: &socialName, upper: textLimit) }
                    HStack(spacing: 15) {
                        LabeledTextField(label: "RG", placeholder: "RG", mandatory: true, textfieldText: $rg)
                            .onReceive(Just(rg)) { _ in rg = textFieldDataViewModel.formatNumber(rg, limit: 9) }
                        LabeledTextField(label: "CPF", placeholder: "CPF", mandatory: true, textfieldText: $cpf)
                            .onReceive(Just(cpf)) { _ in cpf = textFieldDataViewModel.formatCPF(cpf) }
                            .foregroundStyle(textFieldDataViewModel.isValidCPF(cpf) ? .black : .red)
                    }
                    LabeledTextField(label: "Filiação", placeholder: "Filiação", mandatory: true, textfieldText: $affiliation)
                        .onReceive(Just(affiliation)) { _ in textFieldDataViewModel.limitText(text: &affiliation, upper: textLimit) }
                    LabeledTextField(label: "Nacionalidade", placeholder: "Nacionalidade", mandatory: true, textfieldText: $nationality)
                        .onReceive(Just(nationality)) { _ in textFieldDataViewModel.limitText(text: &nationality, upper: textLimit) }
                    
                    HStack(spacing: 15) {
                        LabeledTextField(label: "Estado Civil", placeholder: "Estado Civil", mandatory: true, textfieldText: $maritalStatus)
                            .onReceive(Just(maritalStatus)) { _ in textFieldDataViewModel.limitMaritalStatus(maritalStatus: &maritalStatus, upper: maritalStatusLimit) }
                        LabeledTextField(label: "Profissão", placeholder: "Insira a profissão do Cliente", textfieldText: $Occupation)
                            .onReceive(Just(Occupation)) { _ in textFieldDataViewModel.limitText(text: &Occupation, upper: textLimit) }
                    }
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 2)
            }
        } else if formType == .address {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 15) {
                    LabeledTextField(label: "CEP", placeholder: "CEP", mandatory: true, textfieldText: $cep)
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
                    LabeledTextField(label: "Endereço", placeholder: "Endereço", mandatory: true, textfieldText: $address)
                        .onReceive(Just(address)) { _ in textFieldDataViewModel.limitText(text: &address, upper: textLimit) }
                    
                    HStack(spacing: 15) {
                        LabeledTextField(label: "Número", placeholder: "Número", mandatory: true, textfieldText: $addressNumber)
                            .onReceive(Just(addressNumber)) { _ in addressNumber = textFieldDataViewModel.formatNumber(addressNumber, limit: 7) }
                        LabeledTextField(label: "Bairro", placeholder: "Bairro", mandatory: true, textfieldText: $neighborhood)
                            .onReceive(Just(neighborhood)) { _ in textFieldDataViewModel.limitText(text: &neighborhood, upper: textLimit) }
                        LabeledTextField(label: "Complemento", placeholder: "Complemento", textfieldText: $complement)
                    }
                    HStack(spacing: 15) {
                        LabeledTextField(label: "Estado", placeholder: "Insira seu estado", mandatory: true, textfieldText: $state)
                        LabeledTextField(label: "Cidade", placeholder: "Insira sua cidade", mandatory: true, textfieldText: $city)
                    }
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 2)
            }
            
            
        } else if formType == .contact {
            VStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 4) {
                    LabeledTextField(label: "E-mail", placeholder: "Insira o e-mail do Cliente", mandatory: true, textfieldText: $email)
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
                                .padding(.vertical, -10)
                                .padding(.horizontal, 5)
                            Spacer()
                        }
                    }
                    LabeledTextField(label: "Telefone", placeholder: "Telefone", textfieldText: $telephone)
                        .onReceive(Just(telephone)) { _ in telephone = textFieldDataViewModel.formatPhoneNumber(telephone, cellphone: false) }
                    LabeledTextField(label: "Celular", placeholder: "Celular", mandatory: true, textfieldText: $cellphone)
                        .onReceive(Just(cellphone)) { _ in cellphone = textFieldDataViewModel.formatPhoneNumber(cellphone, cellphone: true) }
                
                Spacer()
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 2)
        }
    }
}
