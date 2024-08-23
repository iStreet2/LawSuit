//
//  CloudTestingView.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 22/08/24.
//

import Foundation
import SwiftUI

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
					var client = Bonito(name: "Micher", myList: [0,0,0,0,0])
					var secondClient = Paulo(name: "Bonito", age: 20)
					var thirdClient = Paulo(name: "Paulo", age: 21)
					
					await ckvm.cloudManager.saveObject(object: &client)
					await ckvm.cloudManager.saveObject(object: &secondClient)
					await ckvm.cloudManager.saveObject(object: &thirdClient)
					
					await ckvm.cloudManager.relateObjectToObject(parentObject: client, objectToRelateToParent: secondClient)
					await ckvm.cloudManager.relateObjectToObject(parentObject: client, objectToRelateToParent: thirdClient)
//					await ckvm.cloudManager.updateRecordWithID(object: client, key: "age", newValue: 18)
					
//					await ckvm.cloudManager.deleteObject(object: client)
				}
			} label: {
				Text("Criar")
			}
		}
	}
}
