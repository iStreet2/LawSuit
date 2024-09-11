//
//  AddClientType.swift
//  LawSuit
//
//  Created by André Enes Pecci on 27/08/24.
//

import SwiftUI
import Combine

enum ClientType {
    case personalInfo, address, contact, others
}

struct AddClientForm: View {
    //MARK: ViewModels
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    @EnvironmentObject var addressViewModel: AddressViewModel
    
    @Binding var stage: Int
    
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
    
    @State var addressApi = AddressAPI()
    
    let textLimit = 50
    let maritalStatusLimit = 10
    
    var body: some View {
        // if stage == 1
        if stage == 1 {
            HStack {
                VStack(spacing: 15) {
                    LabeledTextField(label: "Nome Completo", placeholder: "Insira o nome do Cliente", textfieldText: $name)
                        .onReceive(Just(name)) { _ in textFieldDataViewModel.limitText(text: &name, upper: textLimit) }
                    LabeledTextField(label: "RG", placeholder: "Insira o RG do Cliente", textfieldText: $rg)
                        .onReceive(Just(rg)) { _ in rg = textFieldDataViewModel.formatNumber(rg, limit: 9) }
                    LabeledTextField(label: "Filiação", placeholder: "Insira a Filiação do Cliente", textfieldText: $affiliation)
                        .onReceive(Just(affiliation)) { _ in textFieldDataViewModel.limitText(text: &affiliation, upper: textLimit) }
                    LabeledTextField(label: "Nacionalidade", placeholder: "Insira a Nacionalidade do Cliente", textfieldText: $nationality)
                        .onReceive(Just(nationality)) { _ in textFieldDataViewModel.limitText(text: &nationality, upper: textLimit) }
                }
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "Profissão", placeholder: "Insira a Profissão do Cliente", textfieldText: $occupation)
                        .onReceive(Just(nationality)) { _ in textFieldDataViewModel.limitText(text: &occupation, upper: textLimit) }
                    LabeledTextField(label: "CPF", placeholder: "Insira o CPF do Cliente", textfieldText: $cpf)
                        .onReceive(Just(cpf)) { _ in cpf = textFieldDataViewModel.formatCPF(cpf) }
                        .foregroundStyle(textFieldDataViewModel.isValidCPF(cpf) ? .black : .red)
                    LabeledTextField(label: "Estado Civil", placeholder: "Insira o Estado Civil do Cliente", textfieldText: $maritalStatus)
                        .onReceive(Just(maritalStatus)) { _ in textFieldDataViewModel.limitMaritalStatus(maritalStatus: &maritalStatus, upper: maritalStatusLimit) }
                    LabeledDateField(selectedDate: $birthDate, label: "Data de Nascimento")
                    
                }
            }
            .padding(.vertical, 5)
        } else if stage == 2 {
            VStack(alignment: .leading, spacing: 15) {
                LabeledTextField(label: "CEP", placeholder: "Insira seu CEP", textfieldText: $cep)
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
                LabeledTextField(label: "Endereço", placeholder: "Insira seu endereço", textfieldText: $address)
                HStack(spacing: 10) {
                    LabeledTextField(label: "Número", placeholder: "Insira o número", textfieldText: $addressNumber)
                        .frame(width: 120)
                        .onReceive(Just(addressNumber)) { _ in addressNumber = textFieldDataViewModel.formatNumber(addressNumber, limit: 7)}
                    LabeledTextField(label: "Bairro", placeholder: "Insira seu bairro", textfieldText: $neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Insira o complemento", textfieldText: $complement)
                        .frame(width: 170)
                }
                HStack(spacing: 10) {
                    LabeledTextField(label: "Estado", placeholder: "Insira seu estado", textfieldText: $state)
                    LabeledTextField(label: "Cidade", placeholder: "Insira sua cidade", textfieldText: $city)
                }
            }
            .padding(.vertical, 5)
        } else if stage == 3 {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "E-mail", placeholder: "Insira seu e-mail", textfieldText: $email)
                    HStack(spacing: 60) {
                        LabeledTextField(label: "Telefone", placeholder: "Insira seu telefone", textfieldText: $telephone)
                            .onReceive(Just(telephone)) { _ in telephone = textFieldDataViewModel.formatPhoneNumber(telephone, cellphone: false) }
                        LabeledTextField(label: "Celular", placeholder: "Insira seu celular", textfieldText: $cellphone)
                            .onReceive(Just(cellphone)) { _ in cellphone = textFieldDataViewModel.formatPhoneNumber(cellphone, cellphone: true) }
                    }
                }
            }
            Spacer()
                .padding(.vertical, -5)
        }
    }
}

