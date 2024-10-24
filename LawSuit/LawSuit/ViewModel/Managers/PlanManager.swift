//
//  PlanManager.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 23/10/24.
//

import Foundation
import SwiftUI
import CoreData

class PlanManager: ObservableObject {
	@Published var plan: Plan = .free
	@Published var isPlanSheetPresented: Bool = false
	
	func updatePlan(to plan: Plan, for context: NSManagedObjectContext) {
		self.plan = plan
		
		let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
		userFetchRequest.fetchLimit = 1
		
		do {
			let user = try context.fetch(userFetchRequest).first
			
			user?.plan = plan.rawValue
			try context.save()
		} catch {
			print("Error fetching user: \(error)")
		}
	}
	
	func resetPlan() {
		self.plan = .free
	}
	
	func showPlanView() {
		self.isPlanSheetPresented = true
	}
	
	func isNotFreePlan() -> Bool {
		return plan != .free
	}
	
	func isFreePlan() -> Bool {
		return plan == .free
	}
	
	func getSavedPlan(using context: NSManagedObjectContext) {
		let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
		userFetchRequest.fetchLimit = 1
		
		do {
			let user = try context.fetch(userFetchRequest).first
			
			self.plan = Plan(string: user?.plan ?? "free") ?? .free
		} catch {
			print("Error fetching user: \(error)")
		}
	}
	
	func canAddClient(using context: NSManagedObjectContext) -> Bool {
		if isNotFreePlan() {
			return true
		}
		
		let clientFetchRequest: NSFetchRequest<Client> = Client.fetchRequest()
		
		do {
			let clients = try context.fetch(clientFetchRequest)
			
			return clients.count < 10
		} catch {
			print("Error fetching clients: \(error)")
		}
		return false
	}

}

enum Plan: String {
	case free
	case solo
	case premium
	
	init?(string: String) {
		switch string.lowercased() {
			case "free":
			self = .free
		case "solo":
			self = .solo
		case "premium":
			self = .premium
		default:
			return nil
		}
	}
}
