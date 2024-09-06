//
//  Entity+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 05/09/24.
//
//

import Foundation
import CoreData

@objc(Entity)
public class Entity: NSManagedObject, Identifiable, Recordable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Entity> {
        return NSFetchRequest<Entity>(entityName: "Entity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String
    @NSManaged public var recordName: String?
    
}
