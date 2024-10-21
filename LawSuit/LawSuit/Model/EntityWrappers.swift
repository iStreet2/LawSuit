//
//  EntityWrappers.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 18/09/24.
//

import Foundation

protocol EntityWrapper: Identifiable {
	var entityName: String { get set }
	var id: String { get }
}

struct FileWrapper: EntityWrapper {
	var id: String {
		return file.id!
	}
	
	var entityName: String {
		get {
			return file.name ?? "N/A"
		}
		set {
			
		}
	}
	
	let file: FilePDF
	
	init(file: FilePDF) {
		self.file = file
	}
	
}

struct ClientWrapper: EntityWrapper {
	var id: String {
		return client.id
	}
	
	var entityName: String {
		get {
			return self.client.name
		}
		set {
			self.client.name = newValue
		}
	}
	
	let client: Client
	
	init(client: Client) {
		self.client = client
	}
}

struct LawsuitWrapper: EntityWrapper {
	var id: String {
		return lawsuit.id
	}
	
	var entityName: String {
		get {
            return self.lawsuit.name
		}
		set {
            self.lawsuit.name = newValue
		}
	}
	
	let lawsuit: Lawsuit
	
	init(lawsuit: Lawsuit) {
		self.lawsuit = lawsuit
	}
}
