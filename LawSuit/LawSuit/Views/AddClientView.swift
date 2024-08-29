//
//  AddClientView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

struct AddClientView: View {
    
    //MARK: Environments
    @Environment(\.dismiss) var dismiss
    
    //MARK: Variáveis de estado
    @State var stage: Int = 1
    @State var client = ClientMock(name: "", occupation: "", rg: "", cpf: "", affiliation: "", maritalStatus: "", nationality: "", birthDate: Date(), cep: "", address: "", addressNumber: "", neighborhood: "", complement: "", state: "", city: "", email: "", telephone: "", cellphone: "")
    @State var missingInformation = false
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context
    
    
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
            AddClientForm(stage: $stage, clientMock: $client)
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
                        } else {
                            //Lógica para salvar o cliente
                            coreDataViewModel.clientManager.createClient(
                                name: client.name,
                                occupation: client.occupation,
                                rg: client.rg,
                                cpf: client.cpf,
                                /*lawyer: selectedLawyer,*/
                                affiliation: client.affiliation,
                                maritalStatus: client.maritalStatus,
                                nationality: client.nationality,
                                birthDate: client.birthDate,
                                cep: client.cep,
                                address: client.address,
                                addressNumber: client.addressNumber,
                                neighborhood: client.neighborhood,
                                complement: client.complement,
                                state: client.state,
                                city: client.city,
                                email: client.email,
                                telephone: client.telephone,
                                cellphone: client.cellphone
                            )
                            dismiss()
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
            return !client.name.isEmpty &&
            !client.rg.isEmpty &&
            !client.affiliation.isEmpty &&
            !client.nationality.isEmpty &&
            !client.occupation.isEmpty &&
            !client.cpf.isEmpty &&
            !client.maritalStatus.isEmpty &&
            !client.birthDate.description.isEmpty
        }
        else if stage == 2 {
            return !client.cep.isEmpty &&
            !client.address.isEmpty &&
            !client.addressNumber.isEmpty &&
            !client.neighborhood.isEmpty &&
            !client.complement.isEmpty &&
            !client.city.isEmpty &&
            !client.state.isEmpty
        }
        else if stage == 3 {
            return !client.email.isEmpty &&
            !client.telephone.isEmpty &&
            !client.cellphone.isEmpty
        }
        return true
    }
}

//#Preview {
//    @State var clientMock = ClientMock(name: "", occupation: "", rg: "", cpf: "", affiliation: "", maritalStatus: "", nationality: "", birthDate: Date(), cep: "", address: "", addressNumber: "", neighborhood: "", complement: "", state: "", city: "", email: "", telephone: "", cellphone: "")
//    return AddClientView(clientMock: clientMock)
//}
