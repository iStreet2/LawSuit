//
//  FilePDF+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 12/08/24.
//
//

import Foundation
import CoreData

@objc(FilePDF)
public class FilePDF: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilePDF> {
        return NSFetchRequest<FilePDF>(entityName: "FilePDF")
    }

    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var content: Data
    @NSManaged public var parentFolder: Folder
    
}
