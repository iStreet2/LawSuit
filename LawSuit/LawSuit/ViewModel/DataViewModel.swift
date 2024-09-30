//
//  DataViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 04/09/24.
//

import Foundation
import CoreData
import CloudKit
import CoreSpotlight
import CoreServices

class DataViewModel: ObservableObject {
    
    //Aqui instancio apenas uma vez o container do CoreData e do CloudKit
    
    let coreDataContainer = NSPersistentContainer(name: "Model")
    let context: NSManagedObjectContext
    let cloudContainer: CKContainer = CKContainer(identifier: "iCloud.com.TFS.LawSuit.CKContainer")
    
    var coreDataManager: CoreDataManager
    var cloudManager: CloudManager
    var cloudDataConverter: CloudDataConverter
//    var networkManager: NetworkManager
	var spotlightManager: SpotlightManager
	var authenticationManager: AuthenticationManager
	    
    init() {
        self.coreDataContainer.loadPersistentStores { descricao, error in
            if let error = error {
                print("There was an error loading the data from the model: \(error)")
            }
        }
        self.context = coreDataContainer.viewContext
        self.coreDataManager = CoreDataManager(context: context)
        self.cloudDataConverter = CloudDataConverter(context: context, container: cloudContainer)
        self.cloudManager = CloudManager(container: cloudContainer, cloudDataConverter: cloudDataConverter, context: context)
//        self.networkManager = NetworkManager(coreDataManager: self.coreDataManager, cloudManager: self.cloudManager, context: self.context)
		self.spotlightManager = SpotlightManager(container: self.coreDataContainer, context: self.context)
		 self.authenticationManager = AuthenticationManager(context: self.context)
    }
	
	func fetchCoreDataObjects<T: NSManagedObject>(for model: CoreDataModelsEnumerator) -> [T] {
		do {
			return try spotlightManager.fetchCoreDataObjects(for: model)
		} catch {
			print("Could not fetch core data objects for model \(model): \(error)")
		}
		return []
	}
	
	func getSpotlightList(for section: String, using searchString: String) -> [any EntityWrapper] {
		return spotlightManager.getSpotlightList(for: section, using: searchString)
	}
	
	func getSpotlightListTitles(for searchString: String) -> [String] {
		return spotlightManager.getSpotlightListTitles(for: searchString)
	}
	
	func indexObjectsToSpotlight(objects: [NSManagedObject], for modelType: CoreDataModelsEnumerator) {
		spotlightManager.indexObjectsToSpotlight(objects: objects, for: modelType)
	}
    
	
	func removeIndexedObject(_ object: NSManagedObject) {
		spotlightManager.removeIndexedObject(object)
	}
	
	func getObjectByURI(uri: String) -> Recordable? {
		return spotlightManager.getObjectByURI(uri: uri)
	}
	
	func createOffice(name: String, lawyer: Lawyer) async {
		do {
			if let office = await cloudManager.createOffice(name: name, lawyer: lawyer) {
				let user = authenticationManager.fetchUser()
				user?.officeID = office.record?.recordID.recordName
				
				try context.save()
			} else {
				print("cloudManager.createOffice() -> nil")
			}
		} catch {
			print("Error creating office: \(error)")
		}
	}
	
	func getUserOffice() async -> Office? {
		if let user = self.authenticationManager.fetchUser() {  // Se o usuário existir
			if let officeID = user.officeID {  // Se ele já estiver em um escritório
				return await self.cloudManager.getUserOfficeFrom(officeID: officeID)
			} else {  // Usuário existe mas não tem escritório
				return nil
			}
		}
		return nil
	}
	
	func userDidJoinOffice() -> Bool {
		if let user = self.authenticationManager.fetchUser() {
			if let officeID = user.officeID {
				print("Usuário faz parte do escritório: \(officeID)")
				return true
			}
		}
		print("O usuário não faz parte de nenhum escritório")
		return false
	}
	
}

struct StringElement: Identifiable {
	let id = UUID()
	var value: String
}
