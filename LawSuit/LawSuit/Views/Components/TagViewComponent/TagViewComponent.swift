//
//  TagViewComponent.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/08/24.
// mexido por Emily rrararaar

import Foundation
import SwiftUI

enum TagViewStyle {
    case picker
    case bullet
}

enum TagTypeString {
    static func string(from tagType: TagType) -> String {
        switch tagType {
        case .trabalhista:
            return "trabalhista"
        case .penal:
            return "penal"
        case .tributario:
            return "tributario"
        case .ambiental:
            return "ambiental"
        case .civel:
            return "civel"
        case .falencia:
            return "falencia"
        }
    }
}

enum TagType: CaseIterable, Identifiable {
    init?(s: String) {
        switch s.lowercased() {
        case "trabalhista":
            self = .trabalhista
        case "tributário":
            self = .tributario
        case "tributario":
            self = .tributario
        case "penal":
            self = .penal
        case "ambiental":
            self = .ambiental
        case "cível":
            self = .civel
        case "civel":
            self = .civel
        case "falência":
            self = .falencia
        case "falencia":
            self = .falencia
        default:
            self = .trabalhista
        }
    }
    
    var id: Self {
        return self
    }
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
        HStack(spacing: 4) {
            Text(tagType.tagText)
                .font(.callout)
                .bold()
                .foregroundStyle(tagType.tagColorForeground)
                .fixedSize(horizontal: true, vertical: true)
        }
        .padding(.vertical, 1)
        .padding(.horizontal, 8)
        .background(
            tagType.tagColorBackground
                .clipShape(RoundedRectangle(cornerRadius: 45))
        )
        
    }
}



extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

