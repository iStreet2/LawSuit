//
//  MockViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 29/08/24.
//

import Foundation
import SwiftUI

class MockViewModel: ObservableObject {
    
    @Published public var processList: [ProcessMock] = [
        ProcessMock(id: "1", title: "Abigail da Silva x Optimi S.A", client: ClientMock(name: "Abigail da Silva", occupation: "lala", rg: "lala", cpf: "lala", affiliation: "lala", maritalStatus: "lala", nationality: "lala", birthDate: Date(), cep: "lala", address: "lala", addressNumber: "lala", neighborhood: "lala", complement: "lala", state: "lala", city: "lala", email: "lala", telephone: "lala", cellphone: "lala"), tagType: .trabalhista, lastMovement: "22/06/2024 - 9:27", lawyer: LawyerMock(name: "Paulo Sonzzini"), number: "0001234-56.2024.5.00.0000", court: "2", defendant: "lalalal", actionDate: Date(), rootFolder: FolderMock(), recordName: "bla"),
        ProcessMock(id: "1", title: "Laura Silveira x Lipo Race S.A.", client: ClientMock(name: "Laura Silveira", occupation: "lala", rg: "lala", cpf: "lala", affiliation: "lala", maritalStatus: "lala", nationality: "lala", birthDate: Date(), cep: "lala", address: "lala", addressNumber: "lala", neighborhood: "lala", complement: "lala", state: "lala", city: "lala", email: "lala", telephone: "lala", cellphone: "lala"), tagType: .tributario, lastMovement: "22/06/2024 - 9:27", lawyer: LawyerMock(name: "Paulo Sonzzini"), number: "0001234-56.2024.5.00.0000", court: "2", defendant: "lalalal", actionDate: Date(), rootFolder: FolderMock(), recordName: "bla")]
    
    
}
