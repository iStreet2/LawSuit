//
//  ProcessCell.swift
//  LawSuit
//
//  Created by Giovanna Micher on 28/08/24.
//

import SwiftUI

struct LawsuitCellComponent: View {
    var client: ClientMock
    var lawyer: LawyerMock
    var process: ProcessMock
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                Text(process.title!)
                    .font(.callout)
                    .bold()
                Text(process.number)
                    .font(.callout)
                    .foregroundStyle(Color(.gray))
            }
            .padding(.trailing)
//            .frame(width: 195)
//            Spacer()
            TagViewComponent(tagType: process.tagType!)
//            Spacer()

            Group {
                Text(process.lastMovement!)
                Spacer()
                Text(client.name)
                Spacer()
                Text(lawyer.name)
            }
            .font(.callout)
            .bold()
        } 
        .padding(10)
        .frame(width: 777)
    }
}
//
//#Preview {
//    ProcessCell(client: ClientMock(name: "Abigail da Silva", occupation: "lala", rg: "lala", cpf: "lala", affiliation: "lala", maritalStatus: "lala", nationality: "lala", birthDate: Date(), cep: "lala", address: "lala", addressNumber: "lala", neighborhood: "lala", complement: "lala", state: "lala", city: "lala", email: "lala", telephone: "lala", cellphone: "lala"), lawyer: LawyerMock(name: "Paulo Sonzzini"), process: ProcessMock(id: "1", title: "Abigail da Silva x Optimi S.A", client: ClientMock(name: "Abigail da Silva", occupation: "lala", rg: "lala", cpf: "lala", affiliation: "lala", maritalStatus: "lala", nationality: "lala", birthDate: Date(), cep: "lala", address: "lala", addressNumber: "lala", neighborhood: "lala", complement: "lala", state: "lala", city: "lala", email: "lala", telephone: "lala", cellphone: "lala"), tagType: .trabalhista, lastMovement: "22/06/2024 - 9:27", lawyer: LawyerMock(name: "Paulo Sonzzini"), number: "0001234-56.2024.5.00.0000"), court: "2", defendant: "lalalal", actionDate: Date(), rootFolder: FolderMock(), recordName: "bla")
//}
