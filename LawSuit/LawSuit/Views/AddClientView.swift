//
//  AddClientView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

struct AddClientView: View {
    
    @State var fullName: String = ""
    @State var rg: String = ""
    @State var affiliation: String = ""
    @State var nationality: String = ""
    @State var profession: String = ""
    @State var cpf: String = ""
    @State var maritalStatus: String = ""
    @State var dateOfBirth: String = ""
    var body: some View {
        VStack {
            HStack {
                Text("Novo Cliente")
                    .font(.title)
                    .bold()
                    .padding(.leading, 2)
                Spacer()
            }
            .padding()
            
            
            HStack {
                
                VStack(alignment: .leading){
                    Group {
                        Text("Nome Completo")
                        TextField("Insira seu nome", text: $fullName)
                        Text("RG")
                        TextField("Insira seu RG", text: $rg)
                        Text("Filiação")
                        TextField("Insira sua Filiação", text: $affiliation)
                        Text("Nacionalidade")
                        TextField("Insira sua Nacionalidade", text: $nationality)
                    }
                    .bold()
                    .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading) {
                    Group {
                        Text("Profissão")
                        TextField("Insira sua profissão", text: $profession)
                        Text("CPF")
                        TextField("Insira seu CPF", text: $cpf)
                        Text("Estado Civil")
                        TextField("Insira seu Estado Civil", text: $maritalStatus)
                        Text("Data de Nascimento")
                        TextField("Insira sua Data de Nascimento", text: $dateOfBirth)
                    }
                    .bold()
                    .textFieldStyle(.roundedBorder)
                }
            }
            .frame(width: 450)
            
            Spacer()
            //          MARK: Botões
            
            HStack {
                Spacer()
                Button(action: {
                    print("cancelado")
                }, label: {
                    Text("Cancelar")
                })
                Button(action: {
                    print("avançou")
                }, label: {
                    Text("Próximo")
                })
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .frame(width: 490, height: 330)
    }
}

#Preview {
    AddClientView(fullName: "")
}
