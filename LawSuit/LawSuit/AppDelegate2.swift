//
//  AppDelegate.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/09/24.
//

import Foundation
import SwiftUI
import CoreSpotlight

class AppDelegate: NSObject, NSApplicationDelegate {
	
	
	func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any NSUserActivityRestoring]) -> Void) -> Bool {
		
		if userActivity.activityType == CSSearchableItemActionType {
			print("Application Summoned via Spotlight")
			if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
				print(uniqueIdentifier)
				NotificationCenter.default.post(name: NSNotification.Name("HandleSpotlightSearch"), object: uniqueIdentifier)
			}
		}
		return true
		
	}
	
}
