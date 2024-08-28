//
//  AddClientView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

struct AddClientView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var stage: Int = 1
    @State var clientMock = ClientMock(name: "", occupation: "", rg: "", cpf: "", affiliation: "", maritalStatus: "", nationality: "", birthDate: Date(), cep: "", address: "", addressNumber: "", neighborhood: "", complement: "", state: "", city: "", email: "", telephone: "", cellphone: "")
    @State var missingInformation = false
    
    var body: some View {
        VStack() {
            HStack {
                Text("Novo Cliente")
                    .font(.title)
                    .bold()
                    .padding(.leading, 2)
                Spacer()
            }
            // MARK: ProgressBar
            AddClientProgressView(stage: $stage)
            Spacer()
            AddClientForm(stage: $stage, clientMock: $clientMock)
            Spacer()
            //          MARK: Botões
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
                    if areFieldsFilled() {
                        if stage < 3 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                stage += 1
                            }
                        }
                    } else {
                        missingInformation = true
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
                .alert(isPresented: $missingInformation) {
                    Alert(title: Text("Informações Faltando"),
                          message: Text("Por favor, preencha todos os campos antes de continuar."),
                          dismissButton: .default(Text("OK")))
                }
            }
        }
        .padding()
        .frame(width: 500)
    }
    
    // Função para verificar se todos os campos estão preenchidos de acordo com o stage
    func areFieldsFilled() -> Bool {
        if stage == 1 {
            return !clientMock.name.isEmpty &&
            !clientMock.rg.isEmpty &&
            !clientMock.affiliation.isEmpty &&
            !clientMock.nationality.isEmpty &&
            !clientMock.occupation.isEmpty &&
            !clientMock.cpf.isEmpty &&
            !clientMock.maritalStatus.isEmpty &&
            !clientMock.birthDate.description.isEmpty
        }
        else if stage == 2 {
            return !clientMock.cep.isEmpty &&
            !clientMock.address.isEmpty &&
            !clientMock.addressNumber.isEmpty &&
            !clientMock.neighborhood.isEmpty &&
            !clientMock.complement.isEmpty &&
            !clientMock.city.isEmpty &&
            !clientMock.state.isEmpty
        }
        else if stage == 3 {
            return !clientMock.email.isEmpty &&
            !clientMock.telephone.isEmpty &&
            !clientMock.cellphone.isEmpty
        }
        return true
    }
}

#Preview {
    @State var clientMock = ClientMock(name: "", occupation: "", rg: "", cpf: "", affiliation: "", maritalStatus: "", nationality: "", birthDate: Date(), cep: "", address: "", addressNumber: "", neighborhood: "", complement: "", state: "", city: "", email: "", telephone: "", cellphone: "")
    return AddClientView(clientMock: clientMock)
}
