//
//  Folder+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 12/08/24.
//
//

import Foundation
import CoreData

@objc(Folder)
public class Folder: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var parentFolder: Folder?
    @NSManaged public var folders: NSSet?
    @NSManaged public var files: NSSet?
    
}

// MARK: Generated accessors for folders
extension Folder {

    @objc(addFoldersObject:)
    @NSManaged public func addToFolders(_ value: Folder)

    @objc(removeFoldersObject:)
    @NSManaged public func removeFromFolders(_ value: Folder)

    @objc(addFolders:)
    @NSManaged public func addToFolders(_ values: NSSet)

    @objc(removeFolders:)
    @NSManaged public func removeFromFolders(_ values: NSSet)

}

// MARK: Generated accessors for files
extension Folder {

    @objc(addFilesObject:)
    @NSManaged public func addToFiles(_ value: FilePDF)

    @objc(removeFilesObject:)
    @NSManaged public func removeFromFiles(_ value: FilePDF)

    @objc(addFiles:)
    @NSManaged public func addToFiles(_ values: NSSet)

    @objc(removeFiles:)
    @NSManaged public func removeFromFiles(_ values: NSSet)

}
