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
	
	convenience init?(_ record: CKRecord, context: NSManagedObjectContext) {
		guard let entity = NSEntityDescription.entity(forEntityName: "Folder", in: context) else { return nil }
		
		self.init(entity: entity, insertInto: context)
		
		guard
			let files = record[FolderFields.files.rawValue] as? [CKRecord.Reference],
			let folders = record[FolderFields.folders.rawValue] as? [CKRecord.Reference],
			let name = record[FolderFields.name.rawValue] as? String,
			let id = record[FolderFields.id.rawValue] as? String
		else { print("Error initializing Folder from CKRecord"); return nil }
		
		self.id = id
		self.name = name
		
		for file in files {
			CloudManager.getRecordFromReference(file) { record, error in
				if let record = record {
					// MARK: INICIALIZADOR DE FILE POR CKRecord
					if let fileObject = FilePDF(record, context: context) {
						self.addToFiles(fileObject)
					} else {
						print("fileObject could not be created")
					}
				} else {
					print("Error getting file record from reference: \(error!)")
				}
			}
		}
		
		for folder in folders {
			CloudManager.getRecordFromReference(folder) { record, error in
				if let record = record {
					// MARK: INICIALIZADOR DE FOLDER POR CKRecord
					if let folderObject = Folder(record, context: context) {
						self.addToFolders(folderObject)
					} else {
						print("folderObject could not be created")
					}
				} else {
					print("Error getting folder from reference: \(error!)")
				}
			}
		}
		
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
