//
//  CoreDataModelsEnumerator.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/09/24.
//

import Foundation
import CoreSpotlight
import CoreServices

enum CoreDataModelsEnumerator {
	case client
	case lawsuit
	case file
	
	var entityName: String {
		switch self {
		case .client:
			return "Client"
		case .lawsuit:
			return "Lawsuit"
		case .file:
			return "FilePDF"
		}
	}
	
}
