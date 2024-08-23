//
//  File.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import CloudKit

class Paulo: Recordable {
	var recordName: String?
	var name: String
	var age: Int
	
	init(name: String, age: Int) {
		self.name = name
		self.age = age
		self.recordName = nil
	}
}

class Bonito: Recordable {
	var recordName: String?
	var name: String
	var myList: [Int]
	init(name: String, myList: [Int]) {
		self.recordName = nil
		self.name = name
		self.myList = myList
	}
}
