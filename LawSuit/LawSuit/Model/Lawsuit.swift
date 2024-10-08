//
//  Lawsuit.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 08/10/24.
//

import Foundation
import CloudKit

class Lawsuit: Identifiable {
    var id: String
    var actionDate: String
    var authorID: String
    var category: String
    var court: String
    var defendantID: String
    var name: String
    var number: String
    var rootFolder: Folder
    
    var recordName: String? //MARK: Importante

    init(actionDate: String, authorID: String, category: String, court: String, defendantID: String, name: String, number: String) {
        self.actionDate = actionDate
        self.authorID = authorID
        self.category = category
        self.court = court
        self.defendantID = defendantID
        self.id = UUID().uuidString
        self.name = name
        self.number = number
        self.rootFolder = Folder(createdAt: Date.now, name: "root\(name)")
    }
    
    init(_ record: CKRecord) async {
        if let actionDate = record[LawsuitFields.actionDate.rawValue] as? String {
            self.actionDate = actionDate
        } else {
            print("Missing required field: actionDate")
            self.actionDate = "Unknown Date"
        }

        if let authorID = record[LawsuitFields.authorID.rawValue] as? String {
            self.authorID = authorID
        } else {
            print("Missing required field: authorID")
            self.authorID = "Unknown Author"
        }

        if let category = record[LawsuitFields.category.rawValue] as? String {
            self.category = category
        } else {
            print("Missing required field: category")
            self.category = "Unknown Category"
        }

        if let court = record[LawsuitFields.court.rawValue] as? String {
            self.court = court
        } else {
            print("Missing required field: court")
            self.court = "Unknown Court"
        }

        if let defendantID = record[LawsuitFields.defendantID.rawValue] as? String {
            self.defendantID = defendantID
        } else {
            print("Missing required field: defendantID")
            self.defendantID = "Unknown Defendant"
        }

        if let id = record[LawsuitFields.id.rawValue] as? String {
            self.id = id
        } else {
            print("Missing required field: id")
            self.id = UUID().uuidString
        }

        if let name = record[LawsuitFields.name.rawValue] as? String {
            self.name = name
        } else {
            print("Missing required field: name")
            self.name = "Unknown Name"
        }

        if let number = record[LawsuitFields.number.rawValue] as? String {
            self.number = number
        } else {
            print("Missing required field: number")
            self.number = "Unknown Number"
        }

        if let rootFolderReference = record[LawsuitFields.rootFolder.rawValue] as? CKRecord.Reference {
            do {
                if let folderRecord = try await CloudManager.getRecordFromReference(rootFolderReference) {
                    folderObject = Folder(folderRecord)
                    self.rootFolder = folderObject
                }
            } catch {
                print("Root folder could not me converted to a Folder object")
            }
        } else {
            print("Missing required field: rootFolder")
            // Defina um tratamento adequado caso o rootFolder seja obrigatório
        }

        self.recordName = record.recordID.recordName
    }
}
