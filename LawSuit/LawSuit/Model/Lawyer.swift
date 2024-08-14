//
//  Lawyer+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//
//

import Foundation
import CoreData

@objc(Lawyer)
public class Lawyer: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lawyer> {
        return NSFetchRequest<Lawyer>(entityName: "Lawyer")
    }
    
    @NSManaged public var name: String
    @NSManaged public var id: String
    @NSManaged public var photo: Data?
    @NSManaged public var oab: String
    @NSManaged public var clients: NSSet?
    
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
