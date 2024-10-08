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
    let cloudContainer: CKContainer = CKContainer(identifier: "iCloud.com.TFS.LawSuit.CKContainer")
    
    var coreDataManager: CoreDataManager
    var cloudManager: CloudManager
    var cloudDataConverter: CloudDataConverter
//    var networkManager: NetworkManager
	var spotlightManager: SpotlightManager
	var authenticationManager: AuthenticationManager
	
	var user: User?
	var office: Office?
	    
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
		 
		 let request = NSFetchRequest<User>(entityName: "User")
		 do {
			 let result = try context.fetch(request)
			 if let fetchedUser = result.first {
				 self.user = fetchedUser
			 }
		 } catch {
			 print("DataViewModel.init() -> Error fetching user")
		 }
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
	
	func createOffice(name: String, lawyer: Lawyer) async -> Office? {
		do {
			let lawyerRecord = self.cloudManager.makeRecordFromCoredataObject(object: lawyer)
			print("DataViewModel.createOffice() -> Lawyer record to be saved: \(lawyerRecord)")

			let lawyerSavedRecord = try await cloudContainer.publicCloudDatabase.save(lawyerRecord)
			lawyer.recordName = lawyerSavedRecord.recordID.recordName
			
			try context.save()
			
			let ownerReference = CKRecord.Reference(record: lawyerSavedRecord, action: .none)
			
			let officeRecord = CKRecord(recordType: "Office")
			officeRecord.setValue(name, forKey: OfficeFields.name.rawValue)
			officeRecord.setValue([lawyer.email], forKey: OfficeFields.lawyers.rawValue)
			officeRecord.setValue(ownerReference, forKey: OfficeFields.owner.rawValue)
			
			print("DataViewModel.createOffice() -> Office record to be saved: \(officeRecord)")
			let officeSavedRecord = try await cloudContainer.publicCloudDatabase.save(officeRecord)
			
			let newOffice = await Office(officeSavedRecord, context: context)
			self.office = newOffice
			
			lawyer.officeID = officeSavedRecord.recordID.recordName
			
			try context.save()
			
			return newOffice
			
		} catch {
			print("DataViewModel.createOffice() -> Error creating office")
			return nil
		}
	}
	
	func getUserOffice() async -> Office? {
		if let user = self.user {  // Se o usuário existir
			if let officeID = user.officeID {  // Se ele já estiver em um escritório
				return await self.cloudManager.getUserOfficeFrom(officeID: officeID)
			} else {  // Usuário existe mas não tem escritório
				print("DataViewModel.getUserOffice() -> User doesn't have an officeID")
				return nil
			}
		} else {
			print("DataViewModel.getUserOffice -> dataViewModel doesn't have a user")
		}
		return nil
	}
	
	func userDidJoinOffice() -> Bool {
		if let user = self.user {
			if let officeID = user.officeID {
				print("Usuário faz parte do escritório: \(officeID)")
				return true
			} else { print("OfficeID não encontrado no usuário") }
		} else { print("usuário não encontrado") }
		
		print("O usuário não faz parte de nenhum escritório")
		return false
	}
	
	func doesUserExist() -> Bool {
		let request = NSFetchRequest<Lawyer>(entityName: "Lawyer")
		
		do {
			let result = try context.fetch(request)
			
			if result.isEmpty {
				return false
			}
			
		} catch {
			print("DataViewModel.doesUserExist() -> Error fetching user")
		}
		
		return true
	}
	
	func fetchUser() -> Lawyer? {
		if !doesUserExist() {
			return nil
		}
		
		let request = NSFetchRequest<Lawyer>(entityName: "Lawyer")
		
		do {
			let result = try context.fetch(request)
			
			return result[0]
			
		} catch {
			print("DataViewModel.fetchUser() -> Error fetching user")
		}
		
		return nil
	}
	
	func handleSuccessfullLogin(with authorization: ASAuthorization) {
		if self.user != nil {
			_ = self.authenticationManager.handleSuccessfullLogin(with: authorization)
		} else {
			self.user = self.authenticationManager.handleSuccessfullLogin(with: authorization)
		}
	}
	
	func addClientToOffice(client: CKRecord) async {
		guard let user = self.user else { return }
//		self.office?.clients.append(client)  // MARK: atualizar o modelo a ser mostrado, rs -> NÃO FUNCIONA
		await self.cloudManager.addClientToOffice(client: client, user: user)
	}
	
}

struct StringElement: Identifiable {
	let id = UUID()
	var value: String
}
