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
    @Binding var socialName: String
    @Binding var occupation: String
    @Binding var rg: String
    @Binding var cpf: String
    @Binding var affiliation: String
    @Binding var maritalStatus: String
    @Binding var nationality: String
    @Binding var birthDate: String
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
                        HStack(alignment: .top, spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 19)
                                    .frame(width: 134, height: 134)
                                    .foregroundStyle(.white)
                                Button{
                                    print("foto")
                                } label: {
                                    RoundedRectangle(cornerRadius: 19)
                                        .stroke(Color.black, lineWidth: 1)
                                        .frame(width: 134, height: 134)
                                        .overlay {
                                            Image(systemName: "person.crop.rectangle.badge.plus")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 40, height: 29.49)
                                                .foregroundColor(.secondary)
                                        }
                                }
                                .buttonStyle(.plain)
                            }
                            VStack(alignment: .leading){
                                LabeledTextField(label: "Nome Civil", placeholder: "Insira o nome civil do Cliente", mandatory: true, textfieldText: $name)
                                    .onReceive(Just(name)) { _ in textFieldDataViewModel.limitText(text: &name, upper: textLimit) }
                                LabeledTextField(label: "Data de nascimento", placeholder: "Insira a data de nascimento do Cliente", mandatory: true, textfieldText: $birthDate)
                                    .onReceive(Just(birthDate)) { newValue in
                                        birthDate = textFieldDataViewModel.dateValidation(newValue)
                                    }
                                
                            }
                        }
                        LabeledTextField(label: "Nome Social", placeholder: "Insira o nome social do Cliente", textfieldText: $socialName)
                            .onReceive(Just(socialName)) { _ in textFieldDataViewModel.limitText(text: &socialName, upper: textLimit) }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 15) {
                                VStack(alignment: .leading, spacing: 0) {
                                    LabeledTextField(label: "RG", placeholder: "Insira o RG do Cliente", mandatory: true, textfieldText: $rg)
                                        .onReceive(Just(rg)) { _ in rg = textFieldDataViewModel.formatNumber(rg, limit: 9) }
                                    
                                    Spacer()
                                    if rg.count > 0 && rg.count < 9 {
                                        Text("RG inválido")
                                            .foregroundStyle(.red)
                                            .font(.caption)
                                    }
                                }
                                .frame(height: 80)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    LabeledTextField(label: "CPF", placeholder: "Insira o CPF do Cliente", mandatory: true, textfieldText: $cpf)
                                        .onReceive(Just(cpf)) { _ in cpf = textFieldDataViewModel.formatCPF(cpf) }
                                        .foregroundStyle(cpf.count == 14 ? (textFieldDataViewModel.isValidCPF(cpf) ? .black : .red) : .black)
                                    
                                    Spacer()
                                    if cpf.count > 0 && cpf.count < 14 || cpf.count == 14 && !textFieldDataViewModel.isValidCPF(cpf) {
                                        Text("CPF inválido")
                                            .foregroundStyle(.red)
                                            .font(.caption)
                                    }
                                }
                                .frame(height: 80)
                            }
                            .frame(height: 80)
                            
                            LabeledTextField(label: "Filiação", placeholder: "Insira a filiação do Cliente", mandatory: true, textfieldText: $affiliation)
                                .onReceive(Just(affiliation)) { _ in textFieldDataViewModel.limitText(text: &affiliation, upper: textLimit) }
                        }
                        LabeledTextField(label: "Nacionalidade", placeholder: "Insira a nacionalidade do Cliente", mandatory: true, textfieldText: $nationality)
                            .onReceive(Just(nationality)) { _ in textFieldDataViewModel.limitText(text: &nationality, upper: textLimit) }
                        
                        HStack(spacing: 15) {
                            LabeledTextField(label: "Estado Civil", placeholder: "Insira o estado civil do Cliente", mandatory: true, textfieldText: $maritalStatus)
                                .onReceive(Just(maritalStatus)) { _ in textFieldDataViewModel.limitMaritalStatus(maritalStatus: &maritalStatus, upper: maritalStatusLimit) }
                            LabeledTextField(label: "Profissão", placeholder: "Insira a profissão do Cliente", textfieldText: $occupation)
                                .onReceive(Just(occupation)) { _ in textFieldDataViewModel.limitText(text: &occupation, upper: textLimit) }
                            
                        }
                        
                    }
                    Spacer()
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 2)
            }
        } else if stage == 2 {
            VStack(alignment: .leading, spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    VStack(alignment: .leading, spacing: 0) {
                        LabeledTextField(label: "CEP", placeholder: "Insira o CEP do Cliente", mandatory: true, textfieldText: $cep)
                            .onReceive(Just(cep)) { _ in cep = textFieldDataViewModel.formatNumber(cep, limit: 8) }
                            .onChange(of: cep, perform: { _ in
                                Task{
                                    if cep.count == 8{
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
                        Spacer()
                        if cep.count > 0 && cep.count < 8 {
                            Text("CEP não encontrado")
                                .foregroundStyle(.red)
                                .font(.caption)
                        }
                    }
                    .frame(height: 80)
                    LabeledTextField(label: "Endereço", placeholder: "Insira o endereço do Cliente", mandatory: true, textfieldText: $address)
                }
                HStack(spacing: 10) {
                    LabeledTextField(label: "Número", placeholder: "Insira o  número do Cliente", mandatory: true, textfieldText: $addressNumber)
                        .frame(width: 120)
                        .onReceive(Just(addressNumber)) { _ in addressNumber = textFieldDataViewModel.formatNumber(addressNumber, limit: 7)}
                    LabeledTextField(label: "Bairro", placeholder: "Insira o bairro do Cliente", mandatory: true, textfieldText: $neighborhood)
                    LabeledTextField(label: "Complemento", placeholder: "Insira o complemento", textfieldText: $complement)
                        .frame(width: 170)
                }
                HStack(spacing: 10) {
                    LabeledTextField(label: "Estado", placeholder: "Insira o estado do Cliente", mandatory: true, textfieldText: $state)
                    LabeledTextField(label: "Cidade", placeholder: "Insira a cidade do Cliente", mandatory: true, textfieldText: $city)
                }
            }
            Spacer()
                .padding(.vertical, 5)
        } else if stage == 3 {
            VStack(alignment: .leading, spacing: 15) {
                
                VStack(alignment: .leading, spacing: 0) {
                    LabeledTextField(label: "E-mail", placeholder: "Insira o e-mail do Cliente", mandatory: true, textfieldText: $email)
                        .onChange(of: email) { newValue in
                            isEmailValid = textFieldDataViewModel.isValidEmail(newValue)
                        }
                    Spacer()
                    if email.count > 0 && !textFieldDataViewModel.isValidEmail(email){
                        Text("E-mail inválido")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
                .frame(height: 80)
                VStack(alignment: .leading, spacing: 0) {
                    LabeledTextField(label: "Celular", placeholder: "Insira o celular do Cliente", mandatory: true, textfieldText: $cellphone)
                        .onReceive(Just(cellphone)) { _ in cellphone = textFieldDataViewModel.formatPhoneNumber(cellphone, cellphone: true) }
                    Spacer()
                    if cellphone.count > 0 && cellphone.count < 15 {
                        Text("Celular inválido")
                            .foregroundStyle(.red)
                            .font(.caption)
                    }
                }
                .frame(height: 80)
                LabeledTextField(label: "Telefone", placeholder: "Insira o telefone do Cliente", textfieldText: $telephone)
                    .onReceive(Just(telephone)) { _ in telephone = textFieldDataViewModel.formatPhoneNumber(telephone, cellphone: false) }
                 
                if telephone.count > 0 && telephone.count < 14 {
                    Text("Telefone inválido")
                        .foregroundStyle(.red)
                        .font(.caption)
                        .padding(.vertical, -5)
                }
                
            }
            Spacer()
                .padding(.vertical, -5)
        }
    }
}

