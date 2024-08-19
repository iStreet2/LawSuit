//
//  Client+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//
//

import Foundation
import CoreData

@objc(Client)
public class Client: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        return NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var age: Int64
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var photo: Data?
    @NSManaged public var lawsuit: Lawsuit?
    @NSManaged public var lawyer: Lawyer?
    @NSManaged public var rootFolder: Folder?
    
}
