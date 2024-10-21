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
import AuthenticationServices

class DataViewModel: ObservableObject {
    
    //Aqui instancio apenas uma vez o container do CoreData e do CloudKit
    
    let coreDataContainer = NSPersistentContainer(name: "Model")
    let context: NSManagedObjectContext
//    let cloudContainer: CKContainer = CKContainer(identifier: "iCloud.com.TFS.LawSuit.CKContainer")
    
    var coreDataManager: CoreDataManager
//    var cloudManager: CloudManager
//    var cloudDataConverter: CloudDataConverter
	var spotlightManager: SpotlightManager
	private var authenticationManager: AuthenticationManager
    
    
//    var lawsuitNetworkService: LawsuitNetworkingService
    
    init() {
        self.coreDataContainer.loadPersistentStores { descricao, error in
            if let error = error {
                print("There was an error loading the data from the model: \(error)")
            }
        }
        self.context = coreDataContainer.viewContext
        self.coreDataManager = CoreDataManager(context: context)
//        self.cloudDataConverter = CloudDataConverter(context: context, container: cloudContainer)
//        self.cloudManager = CloudManager(container: cloudContainer, cloudDataConverter: cloudDataConverter)
//        self.lawsuitNetworkService = LawsuitNetworkingService(updateManager: UpdateManager(context: context))
		 self.spotlightManager = SpotlightManager(container: self.coreDataContainer, context: self.context)
		 self.authenticationManager = AuthenticationManager(context: context)
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
	
	func handleSuccessfulLogin(with authorization: ASAuthorization) {
		authenticationManager.handleSuccessfulLogin(with: authorization)
		
	}
	func handleLoginError(with error: Error) {
		authenticationManager.handleLoginError(with: error)
	}
	
	/// DataViewModel.checkAccountStatus() -> Bool
	/// Utilizada para verificar se a UsernameView deve ser mostrada ou se a ContentView já deve ser apresentada
	/// Parâmetro de aceitação de status = user possuir username
	/// 0 = Não foi autenticado ainda, precisa ir para a UsernameView
	/// 1 = Já foi autenticado, pode ir para a ContentView
	func checkAccountStatus() -> Bool {
		return authenticationManager.checkAccountStatus()
	}
	
	func deleteUserAccount() {
		authenticationManager.deleteUserAccount()
	}
	
	func printUsers() {
		authenticationManager.printUsers()
	}
}

struct StringElement: Identifiable {
	let id = UUID()
	var value: String
}
