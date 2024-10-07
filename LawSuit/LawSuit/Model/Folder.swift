//
//  Folder.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 07/10/24.
//

import Foundation
import CloudKit

class Folder {
	var createdAt: Date
	var files: [File]
	var folders: [Folder]
	var id: String
	var name: String
	
	// MARK: - Init para dentro do código
	init(createdAt: Date, files: [File] = [], folders: [Folder] = [], id: String, name: String) {
		self.createdAt = createdAt
		self.files = files
		self.folders = folders
		self.id = id
		self.name = name
	}
	
	// MARK: - Init do CloudKit
	init(_ record: CKRecord) async {
		if let createdAt = record[FolderFields.createdAt.rawValue] as? Date {
			self.createdAt = createdAt
		} else {
			print("Folder missing required field: createdAt")
			self.createdAt = Date.now
		}
		
		if let id = record[FolderFields.id.rawValue] as? String {
			self.id = id
		} else {
			print("Folder missing required filed: id")
			self.id = "Unknown id"
		}
		
		if let name = record[FolderFields.name.rawValue] as? String {
			self.name = name
		} else {
			print("Folder missing required field: name")
			self.name = "Unknown name"
		}
		
		if let files = record[FolderFields.files.rawValue] as? [CKRecord.Reference] {
			for file in files {
				do {
					if let fileRecord = try await CloudManager.getRecordFromReference(file) {
						let fileObject = await File(fileRecord)
						self.files.append(fileObject)
					}
				} catch {
					print("Folder: Error initializing a file from reference")
				}
			}
		} else {
			print("Folder missing required field: files")
			self.files = []
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
		} else {
			print("Folder missing required field: folders")
			self.folders = []
		}
	}
}
