//
//  Lawyer+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//
//

import Foundation
import CoreData

@objc(Lawyer)
public class Lawyer: NSManagedObject, Identifiable, Recordable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lawyer> {
        return NSFetchRequest<Lawyer>(entityName: "Lawyer")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var email: String?
    @NSManaged public var officeID: String
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
