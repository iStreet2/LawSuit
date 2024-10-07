//
//  Folder+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Folder)
public class Folder: NSManagedObject, Identifiable, Recordable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Folder> {
        return NSFetchRequest<Folder>(entityName: "Folder")
    }
	
	convenience init?(_ record: CKRecord, context: NSManagedObjectContext) async {
		guard let entity = NSEntityDescription.entity(forEntityName: "Folder", in: context) else { return nil }
		
		self.init(entity: entity, insertInto: context)
		
		if let files = record[FolderFields.files.rawValue] as? [CKRecord.Reference] {
			for file in files {
				do {
					if let fileRecord = try await CloudManager.getRecordFromReference(file) {
						if let fileObject = FilePDF(fileRecord, context: context) {
							self.addToFiles(fileObject)
						}
					}
				} catch {
					print("Error")
				}
			}
		} else { print("FOLDER__INIT__() files") }
		if let folders = record[FolderFields.folders.rawValue] as? [CKRecord.Reference] {
			for folder in folders {
				do {
					if let folderRecord = try await CloudManager.getRecordFromReference(folder) {
						if let folderObject = await Folder(folderRecord, context: context) {
							self.addToFolders(folderObject)
						}
					}
				} catch {
					print("Error")
				}
			}
		} else { print("FOLDER__INIT__() folders") }
		if let name = record[FolderFields.name.rawValue] as? String {
			self.name = name
		} else { print("FOLDER__INIT__() name") }
		if let id = record[FolderFields.id.rawValue] as? String {
			self.id = id
		} else { print("FOLDER__INIT__() id") }
		
	}

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var parentClient: Client? //Ignorar pro CloudKit
    @NSManaged public var files: NSSet? //Reference
    @NSManaged public var folders: NSSet? //Reference
    @NSManaged public var parentLawsuit: Lawsuit? //Ignorar pro CloudKit
    @NSManaged public var parentFolder: Folder? //Ignorar pro ClouKit
    @NSManaged public var recordName: String?

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
