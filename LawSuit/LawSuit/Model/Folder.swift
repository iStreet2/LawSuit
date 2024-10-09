//
//  Folder.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 07/10/24.
//

import Foundation
import CloudKit

class Folder: Recordable, Identifiable {
    var createdAt: Date
    var files: [FilePDF]
    var folders: [Folder]
    var id: String
    var name: String
    var recordName: String?

    // MARK: - Init para dentro do código
    init(createdAt: Date, files: [FilePDF] = [], folders: [Folder] = [], name: String) {
        self.createdAt = createdAt
        self.files = files
        self.folders = folders
        self.id = UUID().uuidString
        self.name = name
    }

    // MARK: - Init do CloudKit
    convenience init(_ record: CKRecord) async {
        // Chama o init principal com valores padrão
        self.init(
            createdAt: Date.now,
            files: [],
            folders: [],
            name: "Unknown Name"
        )
        
        // Sobrescreve os valores com os dados do CKRecord
        if let createdAt = record[FolderFields.createdAt.rawValue] as? Date {
            self.createdAt = createdAt
        }

        if let id = record[FolderFields.id.rawValue] as? String {
            self.id = id
        }

        if let name = record[FolderFields.name.rawValue] as? String {
            self.name = name
        }

        if let files = record[FolderFields.files.rawValue] as? [CKRecord.Reference] {
            for file in files {
                do {
                    if let fileRecord = try await CloudManager.getRecordFromReference(file) {
                        let fileObject = FilePDF(fileRecord)
                        self.files.append(fileObject)
                    }
                } catch {
                    print("Folder: Error initializing a file from reference")
                }
            }
        }

        if let folders = record[FolderFields.folders.rawValue] as? [CKRecord.Reference] {
            for folder in folders {
                do {
                    if let folderRecord = try await CloudManager.getRecordFromReference(folder) {
                        let folderObject = await Folder(folderRecord)
                        self.folders.append(folderObject)
                    }
                } catch {
                    print("Folder: Error initializing a folder from reference")
                }
            }
        }
        
        self.recordName = record.recordID.recordName
    }
}
