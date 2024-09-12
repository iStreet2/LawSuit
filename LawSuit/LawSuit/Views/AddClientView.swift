//
//  AddClientView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI
import Combine

struct AddClientView: View {
    
    //MARK: Environments
    @EnvironmentObject var textFieldDataViewModel: TextFieldDataViewModel
    @Environment(\.dismiss) var dismiss
    
    //MARK: Variáveis de estado
    @State var stage: Int = 1
    @State var invalidInformation: InvalidInformation?
    @State var name: String = ""
    @State var occupation: String = ""
    @State var rg: String = ""
    @State var cpf: String = ""
    @State var affiliation: String = ""
    @State var maritalStatus: String = ""
    @State var nationality: String = ""
    @State var birthDate: Date = Date()
    @State var cep: String = ""
    @State var address: String = ""
    @State var addressNumber: String = ""
    @State var neighborhood: String = ""
    @State var complement: String = ""
    @State var state: String = ""
    @State var city: String = ""
    @State var email: String = ""
    @State var telephone: String = ""
    @State var cellphone: String = ""
    
    
    //MARK: CoreData
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    @FetchRequest(sortDescriptors: []) var lawyers: FetchedResults<Lawyer>
    
    
    var body: some View {
        VStack() {
            HStack {
                Text("Novo Cliente")
                    .font(.title)
                    .bold()
                    .padding(.leading, 2)
                Spacer()
            }
            //MARK: ProgressBar
            AddClientProgressView(stage: $stage)
            Spacer()
            AddClientForm(stage: $stage, name: $name, occupation: $occupation, rg: $rg, cpf: $cpf, affiliation: $affiliation, maritalStatus: $maritalStatus, nationality: $nationality, birthDate: $birthDate, cep: $cep, address: $address, addressNumber: $addressNumber, neighborhood: $neighborhood, complement: $complement, state: $state, city: $city, email: $email, telephone: $telephone, cellphone: $cellphone)
            Spacer()
            //MARK: Botões
            HStack {
                Spacer()
                Button(action: {
                    if stage == 1 {
                        dismiss()
                    }
                    else {
                        if stage > 1 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                stage -= 1
                            }
                        }
                    }
                }, label: {
                    if stage == 1 {
                        Text("Cancelar")
                    }
                    else {
                        Text("Voltar")
                    }
                })
                Button(action: {
                    if !areFieldsFilled(){
                        invalidInformation = .missingInformation
                        return
                    }
                    if cpf.count < 14 || !textFieldDataViewModel.isValidCPF(cpf) {
                        invalidInformation = .invalidCPF
                        return
                    }
                    if stage < 3 {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            stage += 1
                        }
                    } else {
                        //MARK: Advogado temporário
                        let lawyer = lawyers[0]
                        dataViewModel.coreDataManager.clientManager.createClient(name: name, occupation: occupation, rg: rg, cpf: cpf, lawyer: lawyer, affiliation: affiliation, maritalStatus: maritalStatus, nationality: nationality, birthDate: birthDate, cep: cep, address: address, addressNumber: addressNumber, neighborhood: neighborhood, complement: complement, state: state, city: city, email: email, telephone: telephone, cellphone: cellphone)
                        dismiss()
                    }
                    
                }, label: {
                    if stage == 3 {
                        Text("Adicionar Cliente")
                    }
                    else {
                        Text("Próximo")
                    }
                })
                .buttonStyle(.borderedProminent)
                .alert(item: $invalidInformation) { error in
                    switch error {
                    case .missingInformation:
                        return Alert(title: Text("Informações Faltando"),
                                     message: Text("Por favor, preencha todos os campos antes de continuar."),
                                     dismissButton: .default(Text("Ok")))
                    case .invalidCPF:
                        return Alert(title: Text("CPF inválido"),
                                     message: Text("Por favor, insira um CPF válido antes de continuar."),
                                     dismissButton: .default(Text("Ok")))
                        
                    }
                }
            }
        }
        .padding()
        .frame(width: 500)
    }
    
    // Função para verificar se todos os campos estão preenchidos de acordo com o stage
    func areFieldsFilled() -> Bool {
        if stage == 1 {
            return !name.isEmpty &&
            !rg.isEmpty &&
            !affiliation.isEmpty &&
            !nationality.isEmpty &&
            !occupation.isEmpty &&
            !maritalStatus.isEmpty &&
            !birthDate.description.isEmpty
        } else if stage == 2 {
            return !cep.isEmpty &&
            !address.isEmpty &&
            !addressNumber.isEmpty &&
            !neighborhood.isEmpty &&
            !city.isEmpty &&
            !state.isEmpty
        } else if stage == 3 {
            return !email.isEmpty &&
            !telephone.isEmpty &&
            !cellphone.isEmpty
        }
        return true
    }
}

