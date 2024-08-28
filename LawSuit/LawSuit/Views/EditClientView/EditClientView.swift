//
//  EditClientView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

struct EditClientView: View {
    @State var userInfoType = 0
    @State var clientMock: ClientMock

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                //                Image(.foto)
                //                    .resizable()
                //                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    LabeledTextField(label: "Nome Completo", placeholder: "Nome Completo", textfieldText: $clientMock.name)
                    HStack {
                        LabeledDateField(selectedDate: $clientMock.birthDate, label: "Data de nascimento")
                        LabeledTextField(label: "Profissão", placeholder: "Profissão", textfieldText: $clientMock.occupation)
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
                FormsFields(formType: .personalInfo, client: $clientMock)
                    .padding(.vertical, 5)
            } else if userInfoType == 1 {
                FormsFields(formType: .address, client: $clientMock)
                    .padding(.vertical, 5)
            } else if userInfoType == 2 {
                FormsFields(formType: .contact, client: $clientMock)
                    .padding(.vertical, 5)
            } else {
                FormsFields(formType: .others, client: $clientMock)
                    .padding(.top, 10)
            }
            Spacer()
            
            HStack {
                Button {
                    //
                } label: {
                    Text("Apagar Cliente")
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
                
                Spacer()
                Button {
                    //
                } label: {
                    Text("Cancelar")
                }
                
                Button {
                    //
                } label: {
                    Text("Salvar")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .frame(minHeight: 250)
        .padding()
    }
}

#Preview {
    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
    return EditClientView(clientMock: clientMock)
}
