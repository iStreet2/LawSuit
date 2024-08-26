//
//  CloudTestingView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import SwiftUI
import CloudKit

struct CloudTestingView: View {
	
	@StateObject var ckvm: CloudViewModel = CloudViewModel()
	@EnvironmentObject var cdvm: CoreDataViewModel
	
	@Environment(\.managedObjectContext) var context
	
	var body: some View {
		VStack {
			Button {
				Task {
//					var client = Folder(context: context)
//					client.name = "Carlao"
//					client.id = "id daora"
//					var client = Bonito(name: "Micher", myList: [0,0,0,0,0])
//					var secondClient = Paulo(name: "Bonito", age: 20)
//					var thirdClient = Paulo(name: "Paulo", age: 21)
//					
//					await ckvm.cloudManager.saveObject(object: &client)
//					await ckvm.cloudManager.saveObject(object: &secondClient)
//					await ckvm.cloudManager.saveObject(object: &thirdClient)
//					
//					await ckvm.cloudManager.relateObjectToObject(parentObject: client, objectToRelateToParent: secondClient)
//					await ckvm.cloudManager.relateObjectToObject(parentObject: client, objectToRelateToParent: thirdClient)
//					await ckvm.cloudManager.updateRecordWithID(object: client, key: "age", newValue: 18)
					
//					await ckvm.cloudManager.deleteObject(object: client)
					
					var folder = Folder(context: context)
					folder.name = "FolderName"
					
					let subFolder = Folder(context: context)
					subFolder.name = "UBSOFLDER"
					let secondSubFolder = Folder(context: context)
					secondSubFolder.name = "SUUUUUBSBUSBFOLDER"
					
					let subsubfolder = Folder(context: context)
					subsubfolder.name = "bonito"
					
					let subsubsubfolder = Folder(context: context)
					subsubsubfolder.name = "Paulo"
					
					subsubfolder.addToFolders(subsubsubfolder)
					
					folder.addToFolders(secondSubFolder)
					subFolder.addToFolders(subsubfolder)
					
					let file = FilePDF(context: context)
					file.name = "fileNAME"
					
					folder.addToFolders(subFolder)
					folder.addToFiles(file)
					print("Count:", folder.folders?.count)
					
					await ckvm.cloudManager.saveObject(object: &folder)
				}
			} label: {
				Text("Criar")
					.onAppear {
						let query = CKQuery(recordType: "Folder", predicate: NSPredicate(format: "TRUEPREDICATE"))
						
						Task {
							if let records = await ckvm.cloudManager.fetchWithQuery(query) {
								if let objects = await cdvm.recordObjectManager.makeObjectsFromRecords(records: records) {
									print(objects)
								}
							}
							
						}
					}
			}
		}
	}
}
