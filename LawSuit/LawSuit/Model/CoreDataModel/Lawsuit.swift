//
//  Lawsuit+CoreDataClass.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 19/08/24.
//
//

import Foundation
import CoreData
import CloudKit

@objc(Lawsuit)
public class Lawsuit: NSManagedObject, Identifiable, Recordable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lawsuit> {
        return NSFetchRequest<Lawsuit>(entityName: "Lawsuit")
    }
	
	convenience init?(_ record: CKRecord, context: NSManagedObjectContext) async {
		guard let entity = NSEntityDescription.entity(forEntityName: "Lawsuit", in: context) else { return nil }
		
		self.init(entity: entity, insertInto: context)
		
		guard
			let actionDate = record[LawsuitFields.actionDate.rawValue] as? Date,
			let authorId = record[LawsuitFields.authorID.rawValue] as? String,
			let category = record[LawsuitFields.category.rawValue] as? String,
			let court = record[LawsuitFields.court.rawValue] as? String,
			let defendantID = record[LawsuitFields.defendantID.rawValue] as? String,
			let id = record[LawsuitFields.id.rawValue] as? String,
			let name = record[LawsuitFields.name.rawValue] as? String,
			let number = record[LawsuitFields.number.rawValue] as? String,
			let rootFolder = record[LawsuitFields.rootFolder.rawValue] as? CKRecord.Reference
		else { print("Could not initialize Lawsuit from CKRecord") ; return nil }
		
		self.actionDate = actionDate
		self.authorID = authorId
		self.category = category
		self.court = court
		self.defendantID = defendantID
		self.id = id
		self.name = name
		self.number = number
		
		do {
			if let rootFolderRecord = try await CloudManager.getRecordFromReference(rootFolder) {
				if let rootFolderObject = await Folder(rootFolderRecord, context: context) {
					self.rootFolder = rootFolderObject
				}
			}
		} catch {
			print("Error")
		}
		
	}

    @NSManaged public var court: String
    @NSManaged public var actionDate: Date
    @NSManaged public var category: String
    @NSManaged public var defendantID: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var number: String
    @NSManaged public var authorID: String
    @NSManaged public var parentLawyer: Lawyer? //Ignorar para o CloudKit
    @NSManaged public var rootFolder: Folder? //Reference
    @NSManaged public var updates: NSSet?
    @NSManaged public var recordName: String?

}

// MARK: Generated accessors for updates
extension Lawsuit {

    @objc(addUpdatesObject:)
    @NSManaged public func addToUpdates(_ value: Update)

    @objc(removeUpdatesObject:)
    @NSManaged public func removeFromUpdates(_ value: Update)

    @objc(addUpdates:)
    @NSManaged public func addToUpdates(_ values: NSSet)

    @objc(removeUpdates:)
    @NSManaged public func removeFromUpdates(_ values: NSSet)

}
