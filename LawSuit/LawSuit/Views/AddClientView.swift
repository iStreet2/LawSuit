//
//  AddClientView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

struct AddClientView: View{
        
    @State var fullName: String = ""
    @State var rg: String = ""
    @State var affiliation: String = ""
    @State var nationality: String = ""
    @State var profession: String = ""
    @State var cpf: String = ""
    @State var maritalStatus: String = ""
    @State var dateOfBirth: String = ""
    @State var stage: Int = 1
    
    var body: some View {
        VStack() {
            HStack {
                Text("Novo Cliente")
                    .font(.title)
                    .bold()
                    .padding(.leading, 2)
                Spacer()
            }
            .padding()
            
                // MARK: ProgressBar
            VStack() {
                AddClientProgressView(stage: $stage)
                
                Text("Dados Pessoais")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .padding(.trailing, 280)
                
                
            }
            Spacer()
            
            HStack {
                VStack(alignment: .leading){
                    Group {
                        Text("Nome Completo")
                        TextField("Insira seu nome", text: $fullName)
                            .font(.caption)
                        Text("RG")
                        TextField("Insira seu RG", text: $rg)
                            .font(.caption)
                        Text("Filiação")
                        TextField("Insira sua Filiação", text: $affiliation)
                            .font(.caption)
                        Text("Nacionalidade")
                        TextField("Insira sua Nacionalidade", text: $nationality)
                            .font(.caption)
                    }
                    .bold()
                    .textFieldStyle(.roundedBorder)
                }
                VStack(alignment: .leading) {
                    Group {
                        Text("Profissão")
                        TextField("Insira sua profissão", text: $profession)
                            .font(.caption)
                        Text("CPF")
                        TextField("Insira seu CPF", text: $cpf)
                            .font(.caption)
                        Text("Estado Civil")
                        TextField("Insira seu Estado Civil", text: $maritalStatus)
                            .font(.caption)
                        Text("Data de Nascimento")
                        TextField("Insira sua Data de Nascimento", text: $dateOfBirth)
                            .font(.caption)
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
                    if stage < 4 {
                        withAnimation (.bouncy) {
                            stage += 1
                        }
                        
                    }
                }, label: {
                    Text("Próximo")
                })
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .padding(.bottom, 10)
        }
        .frame(width: 490, height: 330)
    }
}

#Preview {
    AddClientView()
}
