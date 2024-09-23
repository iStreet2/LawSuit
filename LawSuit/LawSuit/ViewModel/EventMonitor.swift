//
//  EventMonitor.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/09/24.
//

import Foundation
import Cocoa

class EventManager: ObservableObject {
	
	@Published var spotlightBarIsPresented: Bool = false
	
	func hotkeyDownHandler() {
		spotlightBarIsPresented = true
	}
	
}
