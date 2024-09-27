//
//  AddClientType.swift
//  LawSuit
//
//  Created by André Enes Pecci on 27/08/24.
//

//import SwiftUI
//import Combine
//
//enum ClientType {
//    case personalInfo, address, contact, others
//}
//
//struct AddClientForm: View {
//    //MARK: ViewModels
//    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
//    @EnvironmentObject var addressViewModel: AddressViewModel
//
//    @Binding var stage: Int
//
//    @Binding var name: String
//    @Binding var occupation: String
//    @Binding var rg: String
//    @Binding var cpf: String
//    @Binding var affiliation: String
//    @Binding var maritalStatus: String
//    @Binding var nationality: String
//    @Binding var birthDate: Date
//    @Binding var cep: String
//    @Binding var address: String
//    @Binding var addressNumber: String
//    @Binding var neighborhood: String
//    @Binding var complement: String
//    @Binding var state: String
//    @Binding var city: String
//    @Binding var email: String
//    @Binding var telephone: String
//    @Binding var cellphone: String
//
//    @State var addressApi = AddressAPI()
//    @State var isEmailValid = true
//
//    let textLimit = 50
//    let maritalStatusLimit = 10
//
//    var body: some View {
//        if stage == 1 {
//            HStack {
//                VStack(spacing: 15) {
//                    LabeledTextField(label: "Nome Completo", placeholder: "Insira o nome do Cliente", textfieldText: $name)
//                        .onReceive(Just(name)) { _ in textFieldDataViewModel.limitText(text: &name, upper: textLimit) }
//                    LabeledTextField(label: "RG", placeholder: "Insira o RG do Cliente", textfieldText: $rg)
//                        .onReceive(Just(rg)) { _ in rg = textFieldDataViewModel.formatNumber(rg, limit: 9) }
//                    LabeledTextField(label: "Filiação", placeholder: "Insira a Filiação do Cliente", textfieldText: $affiliation)
//                        .onReceive(Just(affiliation)) { _ in textFieldDataViewModel.limitText(text: &affiliation, upper: textLimit) }
//                    LabeledTextField(label: "Nacionalidade", placeholder: "Insira a Nacionalidade do Cliente", textfieldText: $nationality)
//                        .onReceive(Just(nationality)) { _ in textFieldDataViewModel.limitText(text: &nationality, upper: textLimit) }
//                }
//                VStack(alignment: .leading, spacing: 15) {
//                    LabeledTextField(label: "Profissão", placeholder: "Insira a Profissão do Cliente", textfieldText: $occupation)
//                        .onReceive(Just(occupation)) { _ in textFieldDataViewModel.limitText(text: &occupation, upper: textLimit) }
//                    LabeledTextField(label: "CPF", placeholder: "Insira o CPF do Cliente", textfieldText: $cpf)
//                        .onReceive(Just(cpf)) { _ in cpf = textFieldDataViewModel.formatCPF(cpf) }
//                        .foregroundStyle(cpf.count == 14 ? (textFieldDataViewModel.isValidCPF(cpf) ? .black : .red) : .black)
//                    LabeledTextField(label: "Estado Civil", placeholder: "Insira o Estado Civil do Cliente", textfieldText: $maritalStatus)
//                        .onReceive(Just(maritalStatus)) { _ in textFieldDataViewModel.limitMaritalStatus(maritalStatus: &maritalStatus, upper: maritalStatusLimit) }
//                    LabeledDateField(selectedDate: $birthDate, label: "Data de Nascimento")
//
//                }
//            }
//            .padding(.vertical, 5)
//        } else if stage == 2 {
//            VStack(alignment: .leading, spacing: 15) {
//                LabeledTextField(label: "CEP", placeholder: "Insira o CEP do Cliente", textfieldText: $cep)
//                    .onReceive(Just(cep)) { _ in cep = textFieldDataViewModel.formatNumber(cep, limit: 8) }
//                    .onChange(of: cep, perform: { _ in
//                        Task{
//                            if cep.count >= 8{
//                                if let addressApi = await addressViewModel.fetch(for: cep) {
//                                    cep = addressApi.cep
//                                    address = addressApi.logradouro
//                                    neighborhood = addressApi.bairro
//                                    state = addressApi.estado
//                                    city = addressApi.localidade
//                                }
//                            }
//                        }
//                    })
//                LabeledTextField(label: "Endereço", placeholder: "Insira o endereço do Cliente", textfieldText: $address)
//                HStack(spacing: 10) {
//                    LabeledTextField(label: "Número", placeholder: "Insira o número do Cliente", textfieldText: $addressNumber)
//                        .frame(width: 120)
//                        .onReceive(Just(addressNumber)) { _ in addressNumber = textFieldDataViewModel.formatNumber(addressNumber, limit: 7)}
//                    LabeledTextField(label: "Bairro", placeholder: "Insira o bairro do Cliente", textfieldText: $neighborhood)
//                    LabeledTextField(label: "Complemento", placeholder: "Insira o complemento do Cliente", textfieldText: $complement)
//                        .frame(width: 170)
//                }
//                HStack(spacing: 10) {
//                    LabeledTextField(label: "Estado", placeholder: "Insira o estado do Cliente", textfieldText: $state)
//                    LabeledTextField(label: "Cidade", placeholder: "Insira o cidade do Cliente", textfieldText: $city)
//                }
//            }
//            .padding(.vertical, 5)
//        } else if stage == 3 {
//            HStack(alignment: .top) {
//                VStack(alignment: .leading, spacing: 15) {
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("E-mail")
//                            .bold()
//                            .font(.body)
//                            .foregroundStyle(Color.black)
//                        TextField("Insira o e-mail do Cliente", text: $email)
//                            .font(.body)
//                            .textFieldStyle(.roundedBorder)
//                            .onChange(of: email) { newValue in
//                                isEmailValid = textFieldDataViewModel.isValidEmail(newValue)
//                            }
//                            .foregroundColor(isEmailValid ? .black : .red)
//                    }
//                        if !isEmailValid {
//                            Text("E-mail inválido")
//                                .foregroundStyle(.red)
//                                .font(.caption)
//                                .padding(.vertical, -10)
//                                .padding(.horizontal, 10)
//                        }
//
//                    HStack(spacing: 60) {
//                        LabeledTextField(label: "Telefone", placeholder: "Insira seu telefone", textfieldText: $telephone)
//                            .onReceive(Just(telephone)) { _ in telephone = textFieldDataViewModel.formatPhoneNumber(telephone, cellphone: false) }
//                        LabeledTextField(label: "Celular", placeholder: "Insira seu celular", textfieldText: $cellphone)
//                            .onReceive(Just(cellphone)) { _ in cellphone = textFieldDataViewModel.formatPhoneNumber(cellphone, cellphone: true) }
//                    }
//                }
//            }
//            Spacer()
//                .padding(.vertical, -5)
//        }
//    }
//}

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
    @Binding var socialName: String
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
    @State var isEmailValid = true
    
    let textLimit = 50
    let maritalStatusLimit = 10
    
    var body: some View {
        
        if stage == 1 {
            ScrollView(showsIndicators: false) {
                Group {
                    VStack(alignment: .leading, spacing: 15) {
//                        HStack(alignment: .top) {
//                            Rectangle()
//                                .frame(width: 134, height: 134)
//                                .cornerRadius(10)
//                            VStack(alignment: .leading){
                                LabeledTextField(label: "Nome Civil", placeholder: "Insira o nome civil do Cliente", textfieldText: $name)
                                    .onReceive(Just(name)) { _ in textFieldDataViewModel.limitText(text: &name, upper: textLimit) }
                                LabeledDateField(selectedDate: $birthDate, label: "Data de Nascimento")
                                
//                            }
//                        }
                        LabeledTextField(label: "Nome Social", placeholder: "Insira o nome social do Cliente", textfieldText: $socialName)
                            .onReceive(Just(socialName)) { _ in textFieldDataViewModel.limitText(text: &socialName, upper: textLimit) }
                            .padding(.horizontal, 2)
                        HStack(spacing: 15) {
                            LabeledTextField(label: "RG", placeholder: "Insira o RG do Cliente", textfieldText: $rg)
                                .onReceive(Just(rg)) { _ in rg = textFieldDataViewModel.formatNumber(rg, limit: 9) }
                            LabeledTextField(label: "CPF", placeholder: "Insira o CPF do Cliente", textfieldText: $cpf)
                                .onReceive(Just(cpf)) { _ in cpf = textFieldDataViewModel.formatCPF(cpf) }
                                .foregroundStyle(cpf.count == 14 ? (textFieldDataViewModel.isValidCPF(cpf) ? .black : .red) : .black)
                        }
                        LabeledTextField(label: "Filiação", placeholder: "Insira a filiação do Cliente", textfieldText: $affiliation)
                            .onReceive(Just(affiliation)) { _ in textFieldDataViewModel.limitText(text: &affiliation, upper: textLimit) }
                        LabeledTextField(label: "Nacionalidade", placeholder: "Insira a nacionalidade do Cliente", textfieldText: $nationality)
                            .onReceive(Just(nationality)) { _ in textFieldDataViewModel.limitText(text: &nationality, upper: textLimit) }
                        HStack(spacing: 15) {
                            LabeledTextField(label: "Profissão", placeholder: "Insira a profissão do Cliente", textfieldText: $occupation)
                                .onReceive(Just(occupation)) { _ in textFieldDataViewModel.limitText(text: &occupation, upper: textLimit) }
                            LabeledTextField(label: "Estado Civil", placeholder: "Insira o estado civil do Cliente", textfieldText: $maritalStatus)
                                .onReceive(Just(maritalStatus)) { _ in textFieldDataViewModel.limitMaritalStatus(maritalStatus: &maritalStatus, upper: maritalStatusLimit) }
                        }
                    }
                    
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 2)
            }
        } else if stage == 2 {
            VStack(alignment: .leading, spacing: 15) {
                LabeledTextField(label: "CEP", placeholder: "Insira o CEP do Cliente", textfieldText: $cep)
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
                LabeledTextField(label: "Endereço", placeholder: "Insira o endereço do Cliente", textfieldText: $address)
                HStack(spacing: 10) {
                    LabeledTextField(label: "Número", placeholder: "Número do endereço", textfieldText: $addressNumber)
                        .frame(width: 120)
                        .onReceive(Just(addressNumber)) { _ in addressNumber = textFieldDataViewModel.formatNumber(addressNumber, limit: 7)}
                    LabeledTextField(label: "Bairro", placeholder: "Insira o bairro do Cliente", textfieldText: $neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Insira o complemento", textfieldText: $complement)
                        .frame(width: 170)
                }
                HStack(spacing: 10) {
                    LabeledTextField(label: "Estado", placeholder: "Insira o estado do Cliente", textfieldText: $state)
                    LabeledTextField(label: "Cidade", placeholder: "Insira o cidade do Cliente", textfieldText: $city)
                }
            }
            Spacer()
                .padding(.vertical, 5)
        } else if stage == 3 {
                VStack(alignment: .leading, spacing: 15) {
                    LabeledTextField(label: "E-mail", placeholder: "Insira o e-mail do Cliente", textfieldText: $email)
                            .onChange(of: email) { newValue in
                                isEmailValid = textFieldDataViewModel.isValidEmail(newValue)
                            }
                            .foregroundColor(isEmailValid ? .black : .red)
                    if !isEmailValid {
                        Text("E-mail inválido")
                            .foregroundStyle(.red)
                            .font(.caption)
                            .padding(.vertical, -10)
                            .padding(.horizontal, 5)
                    }
                        LabeledTextField(label: "Telefone", placeholder: "Insira o telefone do Cliente", textfieldText: $telephone)
                            .onReceive(Just(telephone)) { _ in telephone = textFieldDataViewModel.formatPhoneNumber(telephone, cellphone: false) }
                        LabeledTextField(label: "Celular", placeholder: "Insira o celular do Cliente", textfieldText: $cellphone)
                            .onReceive(Just(cellphone)) { _ in cellphone = textFieldDataViewModel.formatPhoneNumber(cellphone, cellphone: true) }
                    
                }
            Spacer()
                .padding(.vertical, -5)
        }
    }
}

