//
//  File.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 07/10/24.
//

import Foundation
import CloudKit

class FilePDF: Recordable, Identifiable {
	
    var id: String
	var name: String
	var content: Data?
	var createdAt: Date
    var recordName: String?
	
	init(name: String, content: Data, createdAt: Date = Date.now) {
		self.id = UUID().uuidString
		self.name = name
		self.content = content
		self.createdAt = createdAt
	}
	
	init(_ record: CKRecord) {
		if let name = record[FileFields.name.rawValue] as? String {
			self.name = name
		} else {
			print("File missing required field: name")
			self.name = "Unknown name"
		}
		
		if let id = record[FileFields.id.rawValue] as? String {
			self.id = id
		} else {
			print("File missing required filed: id")
			self.id = UUID().uuidString
		}
		
		if let content = record[FileFields.content.rawValue] as? CKAsset {
			if let fileURL = content.fileURL {
				do {
					let data = try Data(contentsOf: fileURL)
					self.content = data
				} catch {
					print("File could not get data from Asset")
				}
			}
		} else {
			print("File missing required filed: content")
			self.content = nil
		}
		
		if let createdAt = record[FileFields.createdAt.rawValue] as? Date {
			self.createdAt = createdAt
		} else {
			print("File missing required field: createdAt")
			self.createdAt = Date.now
		}
        
        self.recordName = record.recordID.recordName
	}
}
