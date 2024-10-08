//
//  Update.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 08/10/24.
//

import Foundation

class Update: Identifiable{
    
    var date: String
    var dsc: String
    var name: String
    var file: FilePDF
    var recordName: String
    
    init(date: String, dsc: String, name: String, file: FilePDF, recordName: String) {
        self.date = date
        self.dsc = dsc
        self.name = name
        self.file = file
        self.recordName = recordName
    }
    
}
