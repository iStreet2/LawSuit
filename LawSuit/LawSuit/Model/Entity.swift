//
//  Entity.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 08/10/24.
//

import Foundation
import CloudKit

class Entity: Recordable, Identifiable {
    
    var id: String
    var name: String
    var recordName: String?
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    init(_ record: CKRecord) {
        
        if let id = record[EntityFields.id.rawValue] as? String {
            self.id = id
        } else {
            self.id = "error"
        }
        if let name = record[EntityFields.name.rawValue] as? String {
            self.name = name
        } else {
            self.name = "error"
        }
    }
    
}
