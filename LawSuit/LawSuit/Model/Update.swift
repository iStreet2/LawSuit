//
//  Update+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 14/08/24.
//
//

import Foundation
import CoreData

@objc(Update)
public class Update: NSManagedObject, Identifiable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Update> {
        return NSFetchRequest<Update>(entityName: "Update")
    }

    @NSManaged public var name: String
    @NSManaged public var date: Date
    @NSManaged public var desc: String?
    @NSManaged public var file: FilePDF?

}
