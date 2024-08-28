//
//  ProcessListView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 28/08/24.
//

import SwiftUI

struct ProcessListView: View {
    var processList: [ProcessMock] = [ProcessMock(id: "1", title: "Abigail da Silva x Optimi S.A", client: ClientMock(name: "Abigail da Silva", occupation: "lala", rg: "lala", cpf: "lala", affiliation: "lala", maritalStatus: "lala", nationality: "lala", birthDate: Date(), cep: "lala", address: "lala", addressNumber: "lala", neighborhood: "lala", complement: "lala", state: "lala", city: "lala", email: "lala", telephone: "lala", cellphone: "lala"), tagType: .trabalhista, lastMovement: "22/06/2024 - 9:27", lawyer: LawyerMock(name: "Paulo Sonzzini"), number: "0001234-56.2024.5.00.0000"), ProcessMock(id: "1", title: "Abigail da Silva x Sinale", client: ClientMock(name: "Abigail da Silva", occupation: "lala", rg: "lala", cpf: "lala", affiliation: "lala", maritalStatus: "lala", nationality: "lala", birthDate: Date(), cep: "lala", address: "lala", addressNumber: "lala", neighborhood: "lala", complement: "lala", state: "lala", city: "lala", email: "lala", telephone: "lala", cellphone: "lala"), tagType: .tributario, lastMovement: "22/06/2024 - 9:27", lawyer: LawyerMock(name: "Paulo Sonzzini"), number: "0001234-56.2024.5.00.0000")]
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Processos")
                    .font(.title)
                    .bold()
                Image(systemName: "plus")
                    .font(.title2)
                    .foregroundStyle(Color(.gray))
            }
            .padding(10)
            
            HStack {
                Text("Nome e Número")
                    .font(.footnote)
                Spacer()
                Text("Tipo")
                    .padding(.leading, 50)
                    .font(.footnote)
                Spacer()
                Text("Última movimentação")
                    .padding(.leading, 40)
                    .font(.footnote)
                Spacer()
                Text("Cliente")
                    .font(.footnote)
                Spacer()
                Text("Advogado responsável")
                    .font(.footnote)
            }
            .padding(.horizontal, 10)
            .foregroundStyle(Color(.gray))
            
            
            Divider()
                .padding(.top, 5)
                .padding(.trailing, 10)
            
            ScrollView {
                VStack {
                    ForEach(Array(processList.enumerated()), id: \.offset) { index, process in
                        ProcessCell(client: process.client, lawyer: process.lawyer, process: process)
                            .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
                    }
                }
            }
        }
    }
}


#Preview {
    ProcessListView()
}
