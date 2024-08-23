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
					var client = Paulo(name: "bonito", age: 20)
//					client.name = "Bonito"
//					client.age = 20
					
					await ckvm.cloudManager.saveObject(object: &client)
					await ckvm.cloudManager.updateRecordWithID(object: client, key: "age", newValue: 18)
					
//					await ckvm.cloudManager.deleteObject(object: client)
				}
			} label: {
				Text("Criar")
			}
		}
	}
}
