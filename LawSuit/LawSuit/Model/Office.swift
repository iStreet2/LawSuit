//
//  Office.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/09/24.
//
import Foundation
import CloudKit
import CoreData

class Office: Identifiable, ObservableObject {
    let id = UUID()
    @Published var clients: [Client] = []
    @Published var lawsuits: [Lawsuit] = []
    @Published var entitys: [Entity] = []
    @Published var lawyers: [Lawyer] = []
    @Published var name: String
    @Published var owner: Lawyer?
    @Published var record: CKRecord?
    
    init(clients: [Client] = [], lawsuits: [Lawsuit] = [], entitys: [Entity] = [], lawyers: [Lawyer] = [], name: String, owner: Lawyer, record: CKRecord? = nil) {
        self.clients = clients
        self.lawsuits = lawsuits
        self.entitys = entitys
        self.lawyers = lawyers
        self.name = name
        self.owner = owner
        self.record = record
    }
    
    init?(_ record: CKRecord) async {
        guard
            let name = record[OfficeFields.name.rawValue] as? String
                //            let clients = record[OfficeFields.clients.rawValue] as? [CKRecord.Reference],
                //            let lawsuits = record[OfficeFields.lawsuits.rawValue] as? [CKRecord.Reference],
                //            let lawyers = record[OfficeFields.lawyers.rawValue] as? [CKRecord.Reference],
                //            let owner = record[OfficeFields.owner.rawValue] as? CKRecord.Reference
        else { print("Failed getting NAME initializing Office from record"); return nil }
        
        self.name = name
        
        // Fetch clients asynchronously
        if let clients = record[OfficeFields.clients.rawValue] as? [CKRecord.Reference] {
            for client in clients {
                do {
                    if let record = try await CloudManager.getRecordFromReference(client) {
                        let clientObject = await Client(record)
                        self.clients.append(clientObject)
                    }
                } catch {
                    print("Office.__INIT?()__ error getting client record from reference")
                }
            }
        } else {
            print("ERRO clients Office(): \(record[OfficeFields.clients.rawValue] ?? "")")
            self.clients = []
        }
        
        
        // Fetch lawsuits asynchronously
        if let lawsuits = record[OfficeFields.lawsuits.rawValue] as? [CKRecord.Reference] {
            for lawsuit in lawsuits {
                do {
                    if let record = try await CloudManager.getRecordFromReference(lawsuit) {
                        let lawsuitObject = await Lawsuit(record)
                        self.lawsuits.append(lawsuitObject)
                    }
                } catch {
                    print("Office.__INIT?()__ error getting lawsuit record from reference")
                }
            }
        } else {
            print("ERRO lawsuits Office(): \(record[OfficeFields.lawsuits.rawValue] ?? "")")
            self.lawsuits = []
        }
        
        if let entitys = record[OfficeFields.entitys.rawValue] as? [CKRecord.Reference] {
            for entity in entitys {
                do {
                    if let record = try await CloudManager.getRecordFromReference(entity) {
                        let entityObject = Entity(record)
                        self.entitys.append(entityObject)
                    }
                } catch {
                    print("Office.++INIT?()__ erroe getting entity record from reference")
                }
            }
        } else {
            print("ERRO entitys Office(): \(record[OfficeFields.entitys.rawValue] ?? "")")
            self.entitys = []
        }
        
        
        // Fetch lawyers asynchronously
        if let lawyers = record[OfficeFields.lawyers.rawValue] as? [CKRecord.Reference]{
            for lawyer in lawyers {
                do {
                    if let lawyerRecord = try await CloudManager.getRecordFromReference(lawyer) {
                        let lawyerObject = Lawyer(lawyerRecord)
                        self.lawyers.append(lawyerObject)
                    }
                } catch {
                    print("Office.__INIT?()__ error getting lawyer record from reference")
                }
            }
        } else {
            print("ERRO lawyers Office(): \(record[OfficeFields.lawyers.rawValue] ?? "")")
            self.lawyers = []
        }
        
        // Fetch owner asynchronously
        if let owner = record[OfficeFields.owner.rawValue] as? CKRecord.Reference {
            do {
                if let ownerRecord = try await CloudManager.getRecordFromReference(owner) {
                    let ownerObject = Lawyer(ownerRecord)
                    self.owner = ownerObject
                }
            } catch {
                print("Office.__INIT?()__ error getting owner record from reference")
            }
        } else {
            print("ERRO owner Office(): \(record[OfficeFields.owner.rawValue] ?? "")")
            
        }
    }
}
