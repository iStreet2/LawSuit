//
//  Client+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 23/08/24.
//
//

import Foundation
import CoreData

@objc(Client)
public class Client: NSManagedObject, Identifiable, Recordable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var age: Int64
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var recordName: String?
    @NSManaged public var lawsuits: NSSet? //Reference
    @NSManaged public var parentLawyer: Lawyer?
    @NSManaged public var rootFolder: Folder? //Reference

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
