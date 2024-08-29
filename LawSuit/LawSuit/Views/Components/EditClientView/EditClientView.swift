//
//  EditClientView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

struct EditClientView: View {
    @State var userInfoType = 0
    @State var client: ClientMock
//    @State var nameInput: String = ""
//    @State var occupationInput: String = ""
//    @State var rgInput: String = ""
//    @State var cpfInput: String = ""
//    @State var affiliationInput: String = ""
//    @State var maritalStatusInput: String = ""
//    @State var nationalityInput: String = ""
//    @State var birthDateInput: Date = Date()
    //@State var occupationInput: String
    
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
            .padding(.top, 5)
            .padding(.trailing, 100)
            .pickerStyle(.segmented)
            .labelsHidden()
            Spacer()
            if userInfoType == 0 {
                EditClientViewFormsFields(formType: .personalInfo, client: $client)
            } else if userInfoType == 1 {
                EditClientViewFormsFields(formType: .address, client: $client)
            } else if userInfoType == 2 {
                EditClientViewFormsFields(formType: .others, client: $client)
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
        .frame(minHeight: 300)
        .padding()
    }
}

#Preview {
	@State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn", age: 30)
    return EditClientView(client: clientMock)
}
