//
//  ProcessNotDistributedView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct LawsuitNotDistributedView: View {
    
    @State var clientMock: ClientMock
    @Binding var lawsuitParentAuthorName: String
    @Binding var lawsuitDefendant: String

    var body: some View {
            VStack(alignment: .leading){
                Text("Área")
                    .bold()
                HStack{
                    EditLawsuitAuthorComponent(button: "Atribuir cliente", label: "Autor", lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefendant, defendantOrClient: "client")
                    LabeledTextField(label: "Réu", placeholder: "Adicionar réu ", textfieldText: $lawsuitDefendant)
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

//#Preview {
//    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
//    @State var processMock = ProcessMock(processNumber: "", court: "", defendant: "")
//    return ProcessNotDistributedView(clientMock: clientMock, processMock: processMock)
//}
