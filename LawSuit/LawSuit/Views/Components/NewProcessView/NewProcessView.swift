//
//  NewProcessView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 23/08/24.
//

import SwiftUI

enum ProcessType: String {
    case distributed = "Distribuído"
    case notDistributed = "Não Distribuído"
}

struct NewProcessView: View {
    
    @State var processType: ProcessType = .distributed
    @State var processTypeString: String = ""

    @State var clientMock: ClientMock
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Novo Processo")
                .bold()
                .font(.title)
            
            VStack(alignment: .leading) {
                
                SegmentedControlComponent(
                    selectedOption: $processTypeString, infos: ["Distribuído","Não Distribuído"])
                .frame(width: 150)
            }
            
            if processType == .distributed {
                ProcessDistributedView(clientMock: clientMock)
            } else if processType == .notDistributed {
                ProcessNotDistributedView(clientMock: clientMock)
            }
        }
        .onAppear {
            processTypeString = processType.rawValue
        }
        .onChange(of: processTypeString, perform: { newValue in
            if newValue == "Distribuído" {
                processType = .distributed
            } else {
                processType = .notDistributed
            }
        })
        .frame(width: 500)
    }
        

}

#Preview {
    @State var clientMock = ClientMock(name: "lala", occupation: "sjkcn", rg: "sjkcn", cpf: "sjkcn", affiliation: "sjkcn", maritalStatus: "sjkcn", nationality: "sjkcn", birthDate: Date(), cep: "sjkcn", address: "sjkcn", addressNumber: "sjkcn", neighborhood: "sjkcn", complement: "sjkcn", state: "sjkcn", city: "sjkcn", email: "sjkcn", telephone: "sjkcn", cellphone: "sjkcn")
    return NewProcessView(clientMock: clientMock)
}
