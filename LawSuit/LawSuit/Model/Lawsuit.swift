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
    var isLoading: Bool = false
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

    convenience init(_ record: CKRecord) async {
        // Chama o init principal com valores padrão
        self.init(
            actionDate: "Unknown Date",
            authorID: "Unknown Author",
            category: "Unknown Category",
            court: "Unknown Court",
            defendantID: "Unknown Defendant",
            name: "Unknown Name",
            number: "Unknown Number"
        )

        // Agora sobreescreve os valores com os do CKRecord

        if let actionDate = record[LawsuitFields.actionDate.rawValue] as? String {
            self.actionDate = actionDate
        }

        if let authorID = record[LawsuitFields.authorID.rawValue] as? String {
            self.authorID = authorID
        }

        if let category = record[LawsuitFields.category.rawValue] as? String {
            self.category = category
        }

        if let court = record[LawsuitFields.court.rawValue] as? String {
            self.court = court
        }

        if let defendantID = record[LawsuitFields.defendantID.rawValue] as? String {
            self.defendantID = defendantID
        }

        if let id = record[LawsuitFields.id.rawValue] as? String {
            self.id = id
        }

        if let name = record[LawsuitFields.name.rawValue] as? String {
            self.name = name
        }

        if let number = record[LawsuitFields.number.rawValue] as? String {
            self.number = number
        }

        if let rootFolderReference = record[LawsuitFields.rootFolder.rawValue] as? CKRecord.Reference {
            do {
                if let folderRecord = try await CloudManager.getRecordFromReference(rootFolderReference) {
                    let folderObject = await Folder(folderRecord)
                    self.rootFolder = folderObject
                }
            } catch {
                self.rootFolder = Folder(createdAt: Date.now, name: "Error")
                print("Root folder could not be converted to a Folder object")
            }
        } else {
            self.rootFolder = Folder(createdAt: Date.now, name: "Error")
            print("Missing required field: rootFolder")
            fatalError("Root folder is required")
        }

        self.recordName = record.recordID.recordName
    }
}
