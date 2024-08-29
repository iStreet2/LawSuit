//
//  ProcessMock.swift
//  LawSuit
//
//  Created by Emily Morimoto on 29/08/24.
//  Created by Giovanna Micher on 28/08/24.
//

import Foundation


struct ProcessMock2 {
    var processNumber: Int
    var court: String
}
struct ProcessMock: Identifiable {
    var id: String
    var title: String
    var client: ClientMock
    var tagType: TagType
    var lastMovement: String
    var lawyer: LawyerMock
    var number: String
}
