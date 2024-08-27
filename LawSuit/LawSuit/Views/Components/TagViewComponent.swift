//
//  TagViewComponent.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/08/24.
//

import Foundation
import SwiftUI

enum TagType {
	case trabalhista
	case penal
	case tributario
	case ambiental
	case civel
	case falencia
	
	var tagText: String {
		switch self {
		case .trabalhista:
			return "Trabalhista"
		case .penal:
			return "Penal"
		case .tributario:
			return "Tributário"
		case .ambiental:
			return "Ambiental"
		case .civel:
			return "Cível"
		case .falencia:
			return "Falência"
		}
	}
	
	var tagColorForeground: Color {
		switch self {
		case .trabalhista:
			return Color(.trabalhistaOrange)
		case .penal:
			return Color(.penalPurple)
		case .tributario:
			return Color(.tributarioBlueForeground)
		case .ambiental:
			return Color(.ambientalGreen)
		case .civel:
			return Color(.civelRed)
		case .falencia:
			return Color(.falenciaYellowForeground)
		}
	}
	
	var tagColorBackground: Color {
		switch self {
		case .trabalhista:
			return Color(.trabalhistaOrange).opacity(0.2)
		case .penal:
			return Color(.penalPurple).opacity(0.2)
		case .tributario:
			return Color(.tributarioBlueBackground).opacity(0.2)
		case .ambiental:
			return Color(.ambientalGreen).opacity(0.2)
		case .civel:
			return Color(.civelRed).opacity(0.2)
		case .falencia:
			return Color(.falenciaYellowBackground).opacity(0.2)
		}
	}
}

struct TagViewComponent: View {
	
	let tagType: TagType
	
	var body: some View {
		Text(tagType.tagText)
			.font(.callout)
			.bold()
			.foregroundStyle(tagType.tagColorForeground)
			.padding(.vertical, 1)
			.padding(.horizontal, 10)
			.background(
				tagType.tagColorBackground
					.clipShape(RoundedRectangle(cornerRadius: 45))
			)
	}
}

#Preview {
	VStack {
		TagViewComponent(tagType: .trabalhista)
	}
	.padding(50)
	.background(Color.white)
}
