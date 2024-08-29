//
//  ProcessDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct ProcessDistributedView: View {
    
    @State var textInput = ""
    @State private var birthDate = Date.now
    @State var clientMock: ClientMock

    
    var body: some View {
    
        VStack{
            LabeledTextField(label: "Nº do processo", placeholder: "Nº do processo", textfieldText: $clientMock.addressNumber)
        }
        Text("Vara")
            .bold()
        TextField("Vara", text: $textInput)
            .textFieldStyle(.roundedBorder)
        
        HStack {
            VStack(alignment: .leading){
                EditProcessAuthorComponent(button: "Autor", label: "Alterar cliente", screen: .small)
                Text("Área")
                    .bold()
            }
            
            
            Spacer()
            
            VStack(alignment: .leading){
                HStack {
                    Text("Réu ")
                        .bold()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("Atribuir Cliente")
                    })
                    .buttonStyle(.borderless)
                    .foregroundStyle(.blue)
                }
                
                TextField("Réu", text: $textInput)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 200)
                
                Text("Data de distribuição ")
                    .bold()
                DatePicker(selection: $birthDate, in: ...Date.now, displayedComponents: .date) { }
                    .datePickerStyle(.field)
            }
            
        }
        HStack {
            
            Spacer()
            
            Button {
            } label: {
                Text("Cancelar")
            }
            Button {
                
            } label: {
                Text("Próximo")
            }
            .buttonStyle(.borderedProminent)
            
        }
        
    }
    
    
    
}

#Preview {
    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
    return ProcessDistributedView(clientMock: clientMock)
}
