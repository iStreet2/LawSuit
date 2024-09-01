//
//  ProcessNameCell.swift
//  LawSuit
//
//  Created by Giovanna Micher on 28/08/24.
//

import SwiftUI

struct LawsuitNameCellComponent: View {
    var process: ProcessMock
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(process.title!)
                .font(.callout)
                .bold()
            Text(process.number)
                .font(.callout)
                .foregroundStyle(Color(.gray))
        }
    }
}

//#Preview {
//    ProcessNameCell(process: ProcessMock(id: "1", title: "Abigail da Silva x Optimi S.A", client: ClientMock(name: "Abigail da Silva", occupation: "lala", rg: "lala", cpf: "lala", affiliation: "lala", maritalStatus: "lala", nationality: "lala", birthDate: Date(), cep: "lala", address: "lala", addressNumber: "lala", neighborhood: "lala", complement: "lala", state: "lala", city: "lala", email: "lala", telephone: "lala", cellphone: "lala"), tagType: .trabalhista, lastMovement: "22/06/2024 - 9:27", lawyer: LawyerMock(name: "Paulo Sonzzini"), number: "0001234-56.2024.5.00.0000"))
//}
