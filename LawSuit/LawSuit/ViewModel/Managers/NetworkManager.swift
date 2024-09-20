//
//  NetworkMonitor.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 26/08/24.
//

import Foundation
import CoreData
import Network

final class NetworkManager: ObservableObject {
    
    var coreDataManager: CoreDataManager
    var cloudManager: CloudManager
    var context: NSManagedObjectContext
    
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    private var debounceWorkItem: DispatchWorkItem?
    
    @Published var isConnected = false
    
    init(coreDataManager: CoreDataManager, cloudManager: CloudManager, context: NSManagedObjectContext) {
        
        self.coreDataManager = coreDataManager
        self.cloudManager = cloudManager
        self.context = context
        
        networkMonitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                if self?.isConnected == true {
                    self?.triggerSyncToCloudWithDebounce()
                }
            }
        }
        networkMonitor.start(queue: workerQueue)
    }
    
    private func triggerSyncToCloudWithDebounce() {
        debounceWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            print("Mandando os dados para a nuvem após o debounce")
            Task {
                await self?.syncDataToCloud()
            }
        }
        
        debounceWorkItem = workItem
        workerQueue.asyncAfter(deadline: .now() + 1.0, execute: workItem)
    }
    
    func syncDataToCloud() async {
        let allClients = coreDataManager.clientManager.fetchAllClients()
        let allFolders = coreDataManager.folderManager.fetchAllFolders()
        let allFiles = coreDataManager.filePDFManager.fetchAllFilesPDF()
        let allLawsuits = coreDataManager.lawsuitManager.fetchAllLawsuits()
        
        for client in allClients {
            if client.recordName == nil {
                print("mandando algum cliente")
                var mutableClient = client
                do {
                    try await cloudManager.recordManager.saveObject(object: &mutableClient.rootFolder!, relationshipsToSave: ["folders", "files"])
                    try await cloudManager.recordManager.saveObject(object: &mutableClient, relationshipsToSave: ["rootFolder"])
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                do {
                    let hasChanged = try await cloudManager.recordManager.hasObjectChangedOnCloudKit(localObject: client, relationshipsToCompare: ["rootFolder"])
                    if hasChanged {
                        print("Editando um cliente")
                        let propertyNames = ["name", "occupation", "rg", "cpf", "affiliation", "maritalStatus", "nationality", "birthDate", "cep", "address", "addressNumber", "neighborhood", "complement", "state", "city", "email", "telephone", "cellphone"]
                        let propertyValues: [Any] = [client.name, client.occupation, client.rg, client.cpf, client.affiliation, client.maritalStatus, client.nationality, client.birthDate, client.cep, client.address, client.addressNumber, client.neighborhood, client.complement, client.state, client.city, client.email, client.telephone, client.cellphone]
                        Task {
                            try await cloudManager.recordManager.updateObjectInCloudKit(object: client, propertyNames: propertyNames, propertyValues: propertyValues)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        for folder in allFolders {
            if folder.recordName == nil {
                print("mandando alguma pasta")
                var mutableFolder = folder
                do {
                    try await cloudManager.recordManager.saveObject(object: &mutableFolder, relationshipsToSave: ["folders", "files"])
                    try await cloudManager.recordManager.addReference(from: mutableFolder.parentFolder!, to: mutableFolder, referenceKey: "folders")
                } catch {
                    print(error.localizedDescription)
                }
            } else {
                do {
                    let hasChanged = try await cloudManager.recordManager.hasObjectChangedOnCloudKit(localObject: folder, relationshipsToCompare: ["files","folders"])
                    if hasChanged {
                        print("Editando uma pasta")
                        let propertyNames = ["name"]
                        let propertyValues: [Any] = [folder.name!]
                        Task {
                            try await cloudManager.recordManager.updateObjectInCloudKit(object: folder, propertyNames: propertyNames, propertyValues: propertyValues)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        for file in allFiles {
            if file.recordName == nil {
                print("mandando algum arquivo")
                var mutableFilePDF = file
                do {
                    try await cloudManager.recordManager.saveObject(object: &mutableFilePDF, relationshipsToSave: [])
                    try await cloudManager.recordManager.addReference(from: mutableFilePDF.parentFolder!, to: mutableFilePDF, referenceKey: "files")
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        
        for lawsuit in allLawsuits {
            if lawsuit.recordName == nil {
                print("mandando algum processo")
                var mutableLawsuit = lawsuit
                if coreDataManager.clientManager.authorIsClient(lawsuit: lawsuit) {
                    if var defendant = coreDataManager.entityManager.fetchFromID(id: lawsuit.defendantID) {
                        do {
                            try await cloudManager.recordManager.saveObject(object: &mutableLawsuit.rootFolder!, relationshipsToSave: ["folders", "files"])
                            try await cloudManager.recordManager.saveObject(object: &defendant, relationshipsToSave: [])
                            try await cloudManager.recordManager.saveObject(object: &mutableLawsuit, relationshipsToSave: ["rootFolder"])
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } else {
                    if var defendant = coreDataManager.clientManager.fetchFromId(id: lawsuit.defendantID) {
                        do {
                            try await cloudManager.recordManager.saveObject(object: &mutableLawsuit.rootFolder!, relationshipsToSave: ["folders", "files"])
                            try await cloudManager.recordManager.saveObject(object: &defendant, relationshipsToSave: [])
                            try await cloudManager.recordManager.saveObject(object: &mutableLawsuit, relationshipsToSave: ["rootFolder"])
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
