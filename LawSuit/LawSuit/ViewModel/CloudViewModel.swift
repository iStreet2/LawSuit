//
//  CloudViewModel.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import CloudKit

class CloudViewModel: ObservableObject {
	let container: CKContainer
	let publicDatabase: CKDatabase
	let cloudManager: CloudManager
	
	init() {
		self.container = CKContainer(identifier: "iCloud.com.TFS.LawSuit")
		self.publicDatabase = container.publicCloudDatabase
		
		self.cloudManager = CloudManager(container: container)
	}
	
	
}

