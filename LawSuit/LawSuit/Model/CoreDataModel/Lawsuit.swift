//
//  Lawsuit+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//
//

import Foundation
import CoreData

@objc(Lawsuit)
public class Lawsuit: NSManagedObject, Identifiable, Recordable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lawsuit> {
        return NSFetchRequest<Lawsuit>(entityName: "Lawsuit")
    }

    @NSManaged public var court: String
    @NSManaged public var actionDate: Date
    @NSManaged public var category: String
    @NSManaged public var defendantID: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var number: String
    @NSManaged public var authorID: String
    @NSManaged public var parentLawyer: Lawyer? //Ignorar para o CloudKit
    @NSManaged public var rootFolder: Folder? //Reference
    @NSManaged public var updates: NSSet? //Reference
    @NSManaged public var recordName: String?

}

// MARK: Generated accessors for updates
extension Lawsuit {

    @objc(addUpdatesObject:)
    @NSManaged public func addToUpdates(_ value: Update)

    @objc(removeUpdatesObject:)
    @NSManaged public func removeFromUpdates(_ value: Update)

    @objc(addUpdates:)
    @NSManaged public func addToUpdates(_ values: NSSet)

    @objc(removeUpdates:)
    @NSManaged public func removeFromUpdates(_ values: NSSet)

}
