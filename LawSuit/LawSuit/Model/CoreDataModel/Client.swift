//
//  Client+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 23/08/24.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Client)
public class Client: NSManagedObject, Identifiable, Recordable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }
	
	convenience init?(_ record: CKRecord, context: NSManagedObjectContext) async {
		guard let entity = NSEntityDescription.entity(forEntityName: "Client", in: context) else { print("Error Client(): entity"); return nil }
		
		self.init(entity: entity, insertInto: context)
		
		if let age = record[ClientFields.age.rawValue] as? Int64 {
			self.age = age
		} else { print("age") }
		if let address = record[ClientFields.address.rawValue] as? String {
			self.address = address
		} else { print("address") }
		if let addressNumber = record[ClientFields.addressNumber.rawValue] as? String {
			self.addressNumber = addressNumber
		} else { print("adressNumber") }
		if let affiliation = record[ClientFields.affiliation.rawValue] as? String {
			self.affiliation = affiliation
		} else { print("affiliation") }
		if let birthDate = record[ClientFields.birthDate.rawValue] as? Date {
			self.birthDate = birthDate
		} else { print("birthDate") }
		if let cellphone = record[ClientFields.cellphone.rawValue] as? String {
			self.cellphone = cellphone
		} else { print("cellphone") }
		if let cep = record[ClientFields.cep.rawValue] as? String {
			self.cep = cep
		} else { print("cep") }
		if let city = record[ClientFields.city.rawValue] as? String {
			self.city = city
		} else { print("city") }
		if let complement = record[ClientFields.complement.rawValue] as? String {
			self.complement = complement
		} else { print("complement") }
		if let cpf = record[ClientFields.cpf.rawValue] as? String {
			self.cpf = cpf
		} else { print("cpf") }
		if let createdAt = record[ClientFields.createdAt.rawValue] as? Date {
//			self.createdAt = createdAt  // MARK: Não possui
		} else { print("ClientRecord não possui createdAt") }
		if let email = record[ClientFields.email.rawValue] as? String {
			self.email = email
		} else { print("email") }
		if let id = record[ClientFields.id.rawValue] as? String {
			self.id = id
		} else { print("id") }
		if let maritalStatus = record[ClientFields.maritalStatus.rawValue] as? String {
			self.maritalStatus = maritalStatus
		} else { print("maritalStatus") }
		if let name = record[ClientFields.name.rawValue] as? String {
			self.name = name
		} else { print("name") }
		if let nationality = record[ClientFields.nationality.rawValue] as? String {
			self.nationality = nationality
		} else { print("nationality") }
		if let occupation = record[ClientFields.occupation.rawValue] as? String {
			self.occupation = occupation
		} else { print("occupation") }
		if let rg = record[ClientFields.rg.rawValue] as? String {
			self.rg = rg
		} else { print("rg") }
		if let rootFolder = record[ClientFields.rootFolder.rawValue] as? CKRecord.Reference {
			do {
				if let rootFolderRecord = try await CloudManager.getRecordFromReference(rootFolder) {
					if let folderObject = await Folder(rootFolderRecord, context: context) {
						self.rootFolder = folderObject
					}
				}
			} catch {
				print("Erro pegando rootFolderRecord em init do cliente")
			}
		} else { print("rootFolder") }
		if let state = record[ClientFields.state.rawValue] as? String {
			self.state = state
		} else { print("state") }
		if let telephone = record[ClientFields.telephone.rawValue] as? String {
			self.telephone = telephone
		} else { print("telephone") }
		if let recordName = record[ClientFields.recordName.rawValue] as? String {
			self.recordName = recordName
		} else { print("recordName") }

	}

    @NSManaged public var age: Int64
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var photo: Data?
    @NSManaged public var recordName: String?
    @NSManaged public var parentLawyer: Lawyer? //Ignorar para o CloudKit
    @NSManaged public var rootFolder: Folder? //Reference
    @NSManaged public var occupation: String
    @NSManaged public var rg: String
    @NSManaged public var cpf: String
    @NSManaged public var affiliation: String
    @NSManaged public var maritalStatus: String
    @NSManaged public var nationality: String
    @NSManaged public var birthDate: Date
    @NSManaged public var cep: String
    @NSManaged public var address: String
    @NSManaged public var addressNumber: String
    @NSManaged public var neighborhood: String?
    @NSManaged public var complement: String
    @NSManaged public var state: String
    @NSManaged public var city: String
    @NSManaged public var email: String
    @NSManaged public var telephone: String
    @NSManaged public var cellphone: String
}

// MARK: Generated accessors for lawsuit
extension Client {

    @objc(addLawsuitObject:)
    @NSManaged public func addToLawsuit(_ value: Lawsuit)

    @objc(removeLawsuitObject:)
    @NSManaged public func removeFromLawsuit(_ value: Lawsuit)

    @objc(addLawsuit:)
    @NSManaged public func addToLawsuit(_ values: NSSet)

    @objc(removeLawsuit:)
    @NSManaged public func removeFromLawsuit(_ values: NSSet)

}
