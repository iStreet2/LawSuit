//
//  FilePDF+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//
//

import Foundation
import CoreData
import CloudKit

@objc(FilePDF)
public class FilePDF: NSManagedObject, Identifiable, Recordable {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilePDF> {
        return NSFetchRequest<FilePDF>(entityName: "FilePDF")
    }
	
	convenience init?(_ record: CKRecord, context: NSManagedObjectContext) {
		guard let entity = NSEntityDescription.entity(forEntityName: "FilePDF", in: context) else { return nil }
		
		self.init(entity: entity, insertInto: context)
		
		guard
			let name = record[FileFields.name.rawValue] as? String,
			let content = record[FileFields.data.rawValue] as? Data
		else { print("Error initializing FilePDF from CKRecord"); return nil }
		
		self.name = name
		self.content = content
	}

    @NSManaged public var content: Data?
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var parentFolder: Folder? //Ignorar para o CloudKit
    @NSManaged public var parentUpdate: Update? //Ignorar para o CloudKit
    @NSManaged public var recordName: String?
}
