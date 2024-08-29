//
//  EditClientView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

struct EditClientView: View {
    @State var userInfoType = 0
    @ObservedObject var client: Client
    @State var temporaryClient: ClientMock?
    
    @Environment(\.dismiss) var dismiss
    
    //MARK: CoreData
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    @Environment(\.managedObjectContext) var context

    var onDelete: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                //                Image(.foto)
                //                    .resizable()
                //                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    LabeledTextField(label: "Nome Completo", placeholder: "Nome Completo", textfieldText: $client.name)
                    HStack {
                        LabeledDateField(selectedDate: $client.birthDate, label: "Data de nascimento")
                        LabeledTextField(label: "Profissão", placeholder: "Profissão", textfieldText: $client.occupation)
                            .frame(maxWidth: .infinity)
                            .padding(.leading, 30)
                    }
                    .padding(.top, 2)
                }
            }
            Picker(selection: $userInfoType, label: Text("picker")) {
                Text("Informações Pessoais").tag(0)
                Text("Endereço").tag(1)
                Text("Contato").tag(2)
                Text("Outros").tag(3)
            }
            .padding(.top, 10)
            .padding(.trailing, 100)
            .pickerStyle(.segmented)
            .labelsHidden()
            
            if userInfoType == 0 {
                EditClientViewFormsFields(formType: .personalInfo, client: client)
                    .padding(.vertical, 5)
            } else if userInfoType == 1 {
                EditClientViewFormsFields(formType: .address, client: client)
                    .padding(.vertical, 5)
            } else if userInfoType == 2 {
                EditClientViewFormsFields(formType: .contact, client: client)
                    .padding(.vertical, 5)
            } else {
                EditClientViewFormsFields(formType: .others, client: client)
                    .padding(.top, 10)
            }
            Spacer()
            
            HStack {
//                Button {
//                    dismiss()
//                    coreDataViewModel.clientManager.deleteClient(client: client)
//                    onDelete?()
//                } label: {
//                    Text("Apagar Cliente")
//                }
//                .buttonStyle(.borderedProminent)
//                .tint(.red)
                
                Spacer()
                Button {
                    if let temporaryClient = temporaryClient {
                        client.name = temporaryClient.name
                        client.occupation = temporaryClient.occupation
                        client.rg = temporaryClient.rg
                        client.cpf = temporaryClient.cpf
                        client.affiliation = temporaryClient.affiliation
                        client.maritalStatus = temporaryClient.maritalStatus
                        client.nationality = temporaryClient.nationality
                        client.birthDate = temporaryClient.birthDate
                        client.cep = temporaryClient.cep
                        client.address = temporaryClient.address
                        client.addressNumber = temporaryClient.addressNumber
                        client.neighborhood = temporaryClient.neighborhood
                        client.complement = temporaryClient.complement
                        client.state = temporaryClient.state
                        client.city = temporaryClient.city
                        client.email = temporaryClient.email
                        client.telephone = temporaryClient.telephone
                        client.cellphone = temporaryClient.cellphone
                    }
                    dismiss()
                } label: {
                    Text("Cancelar")
                }
                
                Button {
                    //
                    coreDataViewModel.clientManager.saveContext()
                    dismiss()
                } label: {
                    Text("Salvar")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(minHeight: 250)
        .padding()
        .onAppear {
            temporaryClient = ClientMock()
            temporaryClient!.name = client.name
            temporaryClient!.occupation = client.occupation
            temporaryClient!.rg = client.rg
            temporaryClient!.cpf = client.cpf
            temporaryClient!.affiliation = client.affiliation
            temporaryClient!.maritalStatus = client.maritalStatus
            temporaryClient!.nationality = client.nationality
            temporaryClient!.birthDate = client.birthDate
            temporaryClient!.cep = client.cep
            temporaryClient!.address = client.address
            temporaryClient!.addressNumber = client.addressNumber
            temporaryClient!.neighborhood = client.neighborhood
            temporaryClient!.complement = client.complement
            temporaryClient!.state = client.state
            temporaryClient!.city = client.city
            temporaryClient!.email = client.email
            temporaryClient!.telephone = client.telephone
            temporaryClient!.cellphone = client.cellphone
        }
    }
}

//#Preview {
//    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
//    return EditClientView(clientMock: clientMock)
//}
