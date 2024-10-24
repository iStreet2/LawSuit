//
//  NavigationViewModel.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 04/09/24.
//

import Foundation
import SwiftUI

class NavigationViewModel: ObservableObject {
	
	@Published var selectedClient: Client? = nil
	@Published var isClientSelected: Bool = false
	@Published var isShowingDetailedLawsuitView = false
	@Published var lawsuitToShow: Lawsuit? = nil
	
	@Published var selectedView = SelectedView.clients
	@Published var navigationVisibility: NavigationSplitViewVisibility = .automatic
	
	func clearLawsuitAttributes() {
		self.lawsuitToShow = nil
	}
	
	func isLawsuit() -> Bool {
		switch self.selectedView {
		case .clients:
			return false
		case .lawsuits:
			return true
		case .plans:
			return false
		}
	}
}
