//
//  FilePDF+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//
//

import Foundation
import CoreData

@objc(FilePDF)
public class FilePDF: NSManagedObject, Identifiable, Recordable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilePDF> {
        return NSFetchRequest<FilePDF>(entityName: "FilePDF")
    }

    @NSManaged public var content: Data?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var parentFolder: Folder?
//    @NSManaged public var parentUpdate: Update?
    @NSManaged public var recordName: String?
}
