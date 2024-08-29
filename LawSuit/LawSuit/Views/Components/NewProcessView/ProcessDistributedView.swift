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
    @State var processMock: ProcessMock
    @State var clientMock: ClientMock

    var body: some View {
    
        VStack{
            LabeledTextField(label: "Nº do processo", placeholder: "Nº do processo", textfieldText: $processMock.processNumber)
        }
        VStack{
            LabeledTextField(label: "Vara", placeholder: "Vara", textfieldText: $processMock.court)
        }
        HStack(alignment: .top){
            VStack(alignment: .leading){
                EditProcessAuthorComponent(button: "Alterar cliente", label: "Autor", screen: .small)
                TextField("", text: $clientMock.name)
                    .textFieldStyle(.roundedBorder)
//                    .frame(width: 200)
                Text("Área")
                    .bold()
            }
            
            Spacer()
            
            VStack(alignment: .leading){
                VStack(alignment: .leading){
                    EditProcessAuthorComponent(button: "Atribuir cliente", label: "Réu", screen: .small)
                
                    TextField("", text: $processMock.defendant)
                        .textFieldStyle(.roundedBorder)
//                        .frame(width: 200)
                }
               
                
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
    @State var processMock = ProcessMock(processNumber: "1383984", court: "28382934", defendant: "")
    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
    return ProcessDistributedView(processMock: processMock, clientMock: clientMock)
}
