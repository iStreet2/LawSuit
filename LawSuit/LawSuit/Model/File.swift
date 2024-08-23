//
//  File.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import CloudKit

class Paulo: Recordable {
	var name: String
	var age: Int
	var record: CKRecord?
	
	init(name: String, age: Int) {
		self.name = name
		self.age = age
		self.record = nil
	}
}