//
//  AddClientView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

struct AddClientView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var fullName: String = ""
    @State var rg: String = ""
    @State var affiliation: String = ""
    @State var nationality: String = ""
    @State var profession: String = ""
    @State var cpf: String = ""
    @State var maritalStatus: String = ""
    @State var dateOfBirth = Date.now
    @State var stage: Int = 1
    
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
            .padding()
            // MARK: ProgressBar
            VStack() {
                AddClientProgressView(stage: $stage)
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
                    }
                    .bold()
                    .textFieldStyle(.roundedBorder)
                    Text("Data de Nascimento")
                        .bold()
                    DatePicker(selection: $dateOfBirth, in: ...Date.now, displayedComponents: .date)
                    {
                    }
                    .datePickerStyle(FieldDatePickerStyle())
                }
            }
            .frame(width: 450)
            Spacer()
            //          MARK: Botões
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }, label: {
                    Text("Cancelar")
                })
                Button(action: {
                    if areFieldsFilled() {
                        if stage < 4 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                stage += 1
                            }
                        }
                    } else {
                        missingInformation = true
                    }
                }, label: {
                    Text("Próximo")
                })
                .buttonStyle(.borderedProminent)
                .alert(isPresented: $missingInformation) {
                    Alert(title: Text("Informações Faltando"),
                          message: Text("Por favor, preencha todos os campos antes de continuar."),
                          dismissButton: .default(Text("OK")))
                }
            }
            .padding()
        }
        .frame(width: 490, height: 340)
    }
    
    // Função para verificar se todos os campos estão preenchidos
    func areFieldsFilled() -> Bool {
        return !fullName.isEmpty && !rg.isEmpty && !affiliation.isEmpty &&
        !nationality.isEmpty && !profession.isEmpty && !cpf.isEmpty &&
        !maritalStatus.isEmpty
    }
}

#Preview {
    AddClientView()
}
