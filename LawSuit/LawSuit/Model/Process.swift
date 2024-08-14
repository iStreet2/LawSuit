//
//  Process+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//
//

import Foundation
import CoreData

@objc(Process)
public class Process: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Process> {
        return NSFetchRequest<Process>(entityName: "Process")
    }

    @NSManaged public var name: String
    @NSManaged public var number: String
    @NSManaged public var category: String
    @NSManaged public var defendant: String
    @NSManaged public var actionDate: Date
    @NSManaged public var id: String
    @NSManaged public var lawyer: Lawyer
    @NSManaged public var autor: Client
    @NSManaged public var rootFolder: Folder
    @NSManaged public var updates: NSSet?

}

// MARK: Generated accessors for updates
extension Process {

    @objc(addUpdatesObject:)
    @NSManaged public func addToUpdates(_ value: Update)

    @objc(removeUpdatesObject:)
    @NSManaged public func removeFromUpdates(_ value: Update)

    @objc(addUpdates:)
    @NSManaged public func addToUpdates(_ values: NSSet)

    @objc(removeUpdates:)
    @NSManaged public func removeFromUpdates(_ values: NSSet)

}

