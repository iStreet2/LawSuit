//
//  EventMonitorProtocol.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 16/09/24.
//

import Foundation
import Cocoa

protocol EventMonitorProtocol {
	
	var monitor: Any? { get set }
	var mask: NSEvent.EventTypeMask { get set }
	var handler: ((NSEvent?) -> Void)? { get set }
	
	func startMonitoring(handler: @escaping (NSEvent?) -> Void)
	func stopMonitoring()
	
}
