//
//  ProcessMock.swift
//  LawSuit
//
//  Created by Emily Morimoto on 29/08/24.
//  Created by Giovanna Micher on 28/08/24.
//

import Foundation

struct ProcessMock: Identifiable {
    var id: String?
    var title: String?
    var client: ClientMock
    var tagType: TagType?
    var lastMovement: String?
    var lawyer: LawyerMock
    var number: String
    var court: String
    var defendant: String
    
    var actionDate: Date
    var rootFolder: FolderMock
    var recordName: String
    
    
    
    init() {
        self.id = ""
        self.title = ""
        self.client = ClientMock()
        self.tagType = .ambiental
        self.lastMovement = ""
        self.lawyer = LawyerMock(name: "")
        self.number = ""
        self.court = ""
        self.defendant = ""
        self.actionDate = Date()
        self.rootFolder = FolderMock()
        self.recordName = ""
    }

    
    init(id: String? = nil, title: String? = nil, client: ClientMock, tagType: TagType? = nil, lastMovement: String? = nil, lawyer: LawyerMock, number: String, court: String, defendant: String, actionDate: Date, rootFolder: FolderMock, recordName: String) {
        self.id = id
        self.title = title
        self.client = client
        self.tagType = tagType
        self.lastMovement = lastMovement
        self.lawyer = lawyer
        self.number = number
        self.court = court
        self.defendant = defendant
        self.actionDate = actionDate
        self.rootFolder = rootFolder
        self.recordName = recordName
    }
    
}
