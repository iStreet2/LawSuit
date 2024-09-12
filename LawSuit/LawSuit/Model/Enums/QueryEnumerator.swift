//
//  QueryEnumerator.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 03/09/24.
//

import Foundation
import CloudKit

enum QueryType {
	case file
	case client
	case folder
    case entity
    case lawsuit
	
	var query: CKQuery {
		switch self {
		case .file:
			return CKQuery(recordType: "FilePDF", predicate: NSPredicate(format: "TRUEPREDICATE"))
		case .client:
			return CKQuery(recordType: "Client", predicate: NSPredicate(format: "TRUEPREDICATE"))
		case .folder:
			return CKQuery(recordType: "Folder", predicate: NSPredicate(format: "TRUEPREDICATE"))
        case .entity:
            return CKQuery(recordType: "Entity", predicate: NSPredicate(format: "TRUEPREDICATE"))
        case .lawsuit:
            return CKQuery(recordType: "Lawsuit", predicate: NSPredicate(format: "TRUEPREDICATE"))
		}
	}
}
