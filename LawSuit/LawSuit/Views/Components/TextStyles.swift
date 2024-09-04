//
//  TextStyle.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/08/24.
//

import Foundation
import SwiftUI


struct LargeTitleModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.system(size: 120))
	}
}

struct TitleOneModifier: ViewModifier {
	func body(content: Content) -> some View {
		content
			.font(.system(size: 100))
	}
}

extension Text {
	func largeTitle() -> some View {
		self.modifier(LargeTitleModifier())
	}
	func title1() -> some View {
		self.modifier(TitleOneModifier())
	}
}
