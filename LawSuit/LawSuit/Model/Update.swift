//
//  Update.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 08/10/24.
//

import Foundation

class Update: Recordable, Hashable, Identifiable {
    
    var date: String
    var dsc: String?
    var name: String
    var file: FilePDF?
    var id: String
    var recordName: String?
    
    init(name: String, date: String) {
        self.id = UUID().uuidString
        self.date = date
        self.dsc = dsc
        self.name = name
        self.file = file
    }
    
}
