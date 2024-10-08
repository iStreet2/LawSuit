//
//  User+CoreDataClass.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 07/10/24.
//
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Identifiable {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
		return NSFetchRequest<User>(entityName: "User")
	}
	
	@NSManaged public var lawyerID: String?
	@NSManaged public var officeID: String?
}
