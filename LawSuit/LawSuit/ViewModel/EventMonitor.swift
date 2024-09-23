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
	@Published var filePreviewIsPresented: Bool = false
	
	@Published var fileToPreview: FilePDF? = nil
	
	func hotkeyDownHandler() {
		spotlightBarIsPresented = true
	}
	
	func didSelectFileToPreview(_ file: FilePDF) {
		self.fileToPreview = file
		self.spotlightBarIsPresented = false
		self.filePreviewIsPresented = true
	}
	
}
