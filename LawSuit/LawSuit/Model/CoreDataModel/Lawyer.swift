//
//  Lawyer+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Lawyer)
public class Lawyer: NSManagedObject, Identifiable, Recordable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lawyer> {
        return NSFetchRequest<Lawyer>(entityName: "Lawyer")
    }
	
	convenience init?(_ record: CKRecord, context: NSManagedObjectContext) {
		guard let entity = NSEntityDescription.entity(forEntityName: "Lawyer", in: context) else { return nil }
		
		self.init(entity: entity, insertInto: context)
		
		guard
			let id = record[LawyerFields.id.rawValue] as? String,
			let name = record[LawyerFields.name.rawValue] as? String,
			let email = record[LawyerFields.email.rawValue] as? String,
			let username = record[LawyerFields.username.rawValue] as? String
		else { print("Could not initialize Lawyer from CKRecord"); return nil }
		
		self.id = id
		self.name = name
		self.email = email
		self.username = username
	}

    @NSManaged public var id: String?
    @NSManaged public var name: String?
	 @NSManaged public var officeID: String?
	 @NSManaged public var username: String?
    @NSManaged public var photo: Data?
	 @NSManaged public var email: String?
    @NSManaged public var recordName: String?

}

// MARK: Generated accessors for clients
extension Lawyer {

    @objc(addClientsObject:)
    @NSManaged public func addToClients(_ value: Client)

    @objc(removeClientsObject:)
    @NSManaged public func removeFromClients(_ value: Client)

    @objc(addClients:)
    @NSManaged public func addToClients(_ values: NSSet)

    @objc(removeClients:)
    @NSManaged public func removeFromClients(_ values: NSSet)

}

// MARK: Generated accessors for lawsuits
extension Lawyer {

    @objc(addLawsuitsObject:)
    @NSManaged public func addToLawsuits(_ value: Lawsuit)

    @objc(removeLawsuitsObject:)
    @NSManaged public func removeFromLawsuits(_ value: Lawsuit)

    @objc(addLawsuits:)
    @NSManaged public func addToLawsuits(_ values: NSSet)

    @objc(removeLawsuits:)
    @NSManaged public func removeFromLawsuits(_ values: NSSet)

}
