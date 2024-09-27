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
	
	convenience init?(_ record: CKRecord, context: NSManagedObjectContext) {
		guard let entity = NSEntityDescription.entity(forEntityName: "Client", in: context) else { return nil }
		
		self.init(entity: entity, insertInto: context)
		
		guard
			let age = record[ClientFields.age.rawValue] as? Int64,
			let address = record[ClientFields.address.rawValue] as? String,
			let addressNumber = record[ClientFields.addressNumber.rawValue] as? String,
			let affiliation = record[ClientFields.affiliation.rawValue] as? String,
			let birthDate = record[ClientFields.birthDate.rawValue] as? Date,
			let cellphone = record[ClientFields.cellphone.rawValue] as? String,
			let cep = record[ClientFields.cep.rawValue] as? String,
			let city = record[ClientFields.city.rawValue] as? String,
			let complement = record[ClientFields.complement.rawValue] as? String,
			let cpf = record[ClientFields.cpf.rawValue] as? String,
			let createdAt = record[ClientFields.createdAt.rawValue] as? Date,
			let email = record[ClientFields.email.rawValue] as? String,
			let id = record[ClientFields.id.rawValue] as? String,
			let maritalStatus = record[ClientFields.maritalStatus.rawValue] as? String,
			let name = record[ClientFields.name.rawValue] as? String,
			let nationality = record[ClientFields.nationality.rawValue] as? String,
			let occupation = record[ClientFields.occupation.rawValue] as? String,
			let rg = record[ClientFields.rg.rawValue] as? String,
			let rootFolder = record[ClientFields.rootFolder.rawValue] as? CKRecord.Reference,
			let state = record[ClientFields.state.rawValue] as? String,
			let telephone = record[ClientFields.telephone.rawValue] as? String
		else { return nil }
		
		self.age = age
		self.address = address
		self.addressNumber = addressNumber
		self.affiliation = affiliation
		self.birthDate = birthDate
		self.cellphone = cellphone
		self.cep = cep
		self.city = city
		self.complement = complement
		self.cpf = cpf
		self.email = email
		self.id = id
		self.maritalStatus = maritalStatus
		self.name = name
		self.nationality = nationality
		self.occupation = occupation
		self.rg = rg
		
		CloudManager.getRecordFromReference(rootFolder, completion: { record, error in
			if let record = record {
				self.rootFolder = Folder(record, context: context)
			}
		})

		self.state = state
		self.telephone = telephone
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
    @NSManaged public var neighborhood: String
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
