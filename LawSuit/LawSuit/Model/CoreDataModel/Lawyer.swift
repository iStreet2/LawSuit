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
    @NSManaged public var oab: String?
    @NSManaged public var photo: Data?
    @NSManaged public var clients: NSSet? //Reference
    @NSManaged public var lawsuits: NSSet? //Reference
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

// MARK: Generated accessors for lawsuit
extension Lawyer {

    @objc(addLawsuitObject:)
    @NSManaged public func addToLawsuit(_ value: Lawsuit)

    @objc(removeLawsuitObject:)
    @NSManaged public func removeFromLawsuit(_ value: Lawsuit)

    @objc(addLawsuit:)
    @NSManaged public func addToLawsuit(_ values: NSSet)

    @objc(removeLawsuit:)
    @NSManaged public func removeFromLawsuit(_ values: NSSet)

}
