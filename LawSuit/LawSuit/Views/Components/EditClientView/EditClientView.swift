//
//  EditClientView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

struct EditClientView: View {
    @State private var userInfoType = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
//                Image(.foto)
//                    .resizable()
//                    .frame(width: 100, height: 100)
                VStack(alignment: .leading) {
                    LabeledField(label: "Nome Completo", placeholder: "Nome Completo")
                        .frame(maxWidth: .infinity)
                    HStack {
                        LabeledField(label: "Data de Nascimento", placeholder: "", labeledFieldType: .date)
                        LabeledField(label: "Profissão", placeholder: "Profissão")
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
                FormsFields()
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
    EditClientView()
}
