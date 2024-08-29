//
//  ProcessNotDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct ProcessNotDistributedView: View {
    
    @State var clientMock: ClientMock
    @State var processMock: ProcessMock

    var body: some View {
            VStack(alignment: .leading){
                Text("Área")
                    .bold()
                HStack{
                    EditProcessAuthorComponent(button: "Atribuir cliente", label: "Autor", screen: .small)
                    
                    LabeledTextField(label: "Réu", placeholder: "Adicionar réu ", textfieldText: $processMock.defendant)
                }
            }
        Spacer()
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                } label: {
                    Text("Cancelar")
                }
                Button {
                    
                } label: {
                    Text("Criar")
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
    @State var processMock = ProcessMock(processNumber: "", court: "", defendant: "")
    return ProcessNotDistributedView(clientMock: clientMock, processMock: processMock)
}
