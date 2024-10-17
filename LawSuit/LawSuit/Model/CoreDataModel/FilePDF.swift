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
    @NSManaged public var isEditing: Bool
    @NSManaged public var createdAt: Date
	@NSManaged public var parentFolder: Folder? //Ignorar para o CloudKit
	@NSManaged public var parentUpdate: Update?
	@NSManaged public var recordName: String?
	
//	enum CodingKeys: String, CodingKey {
//		case content
//		case id
//		case name
//	}
	
//	public func encode(to encoder: any Encoder) throws {
//		guard let context = encoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
//			throw EncodingError.invalidValue("", EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Missing managed object context"))
//		}
//		
//		var container = encoder.container(keyedBy: CodingKeys.self)
//		try container.encode(content, forKey: .content)
//		try container.encode(id, forKey: .id)
//		try container.encode(name, forKey: .name)
//	}
//	
//	required convenience public init(from decoder: Decoder) throws {
//		// Obtém o contexto a partir do userInfo do decoder
//		guard let context = decoder.userInfo[CodingUserInfoKey.context!] as? NSManagedObjectContext else {
//			throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Missing managed object context"))
//		}
//		
//		// Inicializa o NSManagedObject no contexto apropriado
//		let entity = NSEntityDescription.entity(forEntityName: "FilePDF", in: context)!
//		self.init(entity: entity, insertInto: context)
//		
//		// Decodifica as propriedades relevantes
//		let container = try decoder.container(keyedBy: CodingKeys.self)
//		self.content = try container.decodeIfPresent(Data.self, forKey: .content)
//		self.id = try container.decodeIfPresent(String.self, forKey: .id)
//		self.name = try container.decodeIfPresent(String.self, forKey: .name)
//	}
}

//extension CodingUserInfoKey {
//	static let context = CodingUserInfoKey(rawValue: "context")
//}
