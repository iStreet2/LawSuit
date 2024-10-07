//
//  TagViewComponent.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/08/24.
// mexido por Emily rrararaar

import Foundation
import SwiftUI

//enum TagTypeString {
//    static func string(from tagType: TagType) -> String {
//        switch tagType {
//        case .trabalhista:
//            return "trabalhista"
//        case .penal:
//            return "penal"
//        case .tributario:
//            return "tributario"
//        case .ambiental:
//            return "ambiental"
//        case .civel:
//            return "civel"
//        case .falencia:
//            return "falencia"
//        }
//    }
//}
//
//enum TagType: CaseIterable, Identifiable {
//    init?(s: String) {
//        switch s.lowercased() {
//		case "trabalhista":
//			self = .trabalhista
//		case "tributário":
//			self = .tributario
//		case "tributario":
//			self = .tributario
//		case "penal":
//			self = .penal
//		case "ambiental":
//			self = .ambiental
//		case "cível":
//			self = .civel
//		case "civel":
//			self = .civel
//		case "falência":
//			self = .falencia
//		case "falencia":
//			self = .falencia
//		default:
//			self = .trabalhista
//		}
//	}
//
//	var id: Self {
//		return self
//	}
//	case trabalhista
//	case penal
//	case tributario
//	case ambiental
//	case civel
//	case falencia
//
//	var tagText: String {
//		switch self {
//		case .trabalhista:
//			return "Trabalhista"
//		case .penal:
//			return "Penal"
//		case .tributario:
//			return "Tributário"
//		case .ambiental:
//			return "Ambiental"
//		case .civel:
//			return "Cível"
//		case .falencia:
//			return "Falência"
//		}
//	}

enum TagViewStyle {
    case picker
    case bullet
}

enum TagType: String, CaseIterable, Identifiable {
    case trabalhista, tributario, penal, ambiental, civel, falencia
    
    var id: String { self.rawValue }
    
    var tagText: String {
        switch self {
        case .trabalhista:
            return "Trabalhista"
        case .tributario:
            return "Tributário"
        case .penal:
            return "Penal"
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
    
//    let tagType: TagType
    let tagViewStyle: TagViewStyle
    var isPicker: Bool = false
    var cornerRadius: CGFloat = 45
    @State var wasTapped: Bool = false
    @EnvironmentObject var lawsuitViewModel: LawsuitViewModel
    
    
    var body: some View {
        
        if tagViewStyle == .bullet {
            HStack(spacing: 4) {
                Text(lawsuitViewModel.tagType.tagText)
                    .font(.callout)
                    .bold()
                    .foregroundStyle(lawsuitViewModel.tagType.tagColorForeground)
                    .fixedSize(horizontal: true, vertical: true)
                if isPicker {
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(lawsuitViewModel.tagType.tagColorForeground)
                }
            }
            .padding(.vertical, 1)
            .padding(.horizontal, (wasTapped && isPicker) ? 30 : 10)
            .background(
                lawsuitViewModel.tagType.tagColorBackground
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            )
        }
        
        if tagViewStyle == .picker {
            Picker("", selection: $lawsuitViewModel.tagType) {
                ForEach(TagType.allCases){ tag in
                    Text(tag.tagText).tag(tag)
                }
            }
            .border(.red)
            .frame(width: 130)
            .pickerStyle(.automatic)
            
        }
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

//struct DropdownPicker: View {
//	@State private var isExpanded: Bool = false
//	@State private var buttonPosition: CGRect = CGRect()
//
//	var body: some View {
//		ZStack(alignment: .topLeading) {
//			VStack {
//				// Botão em forma de pílula
//				Button(action: {
//					withAnimation(.easeInOut) {
//						isExpanded.toggle()
//					}
//				}) {
//					Text("Select an Option")
//						.padding()
//						.background(Capsule().fill(Color.blue))
//						.foregroundColor(.white)
//				}
//				.background(
//					GeometryReader { geo in
//						Color.clear.onAppear {
//							self.buttonPosition = geo.frame(in: .global)
//						}
//					}
//				)
//			}
//			.zIndex(1)
//
//			// Menu suspenso
//			if isExpanded {
//				VStack(spacing: 0) {
//					Text("Option 1")
//						.padding()
//						.frame(maxWidth: .infinity, alignment: .leading)
//					Divider()
//					Text("Option 2")
//						.padding()
//						.frame(maxWidth: .infinity, alignment: .leading)
//					Divider()
//					Text("Option 3")
//						.padding()
//						.frame(maxWidth: .infinity, alignment: .leading)
//				}
//				.background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.2)))
//				.frame(width: buttonPosition.width)
//				.position(x: buttonPosition.midX, y: buttonPosition.maxY + buttonPosition.height / 2)
//				.transition(.move(edge: .top).combined(with: .opacity))
//				.zIndex(0)
//				.clipped()
//			}
//		}
//		.frame(width: 200, height: 300) // Defina o tamanho total da view
//		.padding()
//		.background(Color.white)
//		.cornerRadius(10)
//		.shadow(radius: 5)
//	}
//}

//#Preview {
//	VStack {
//		//		TagViewComponent(tagType: .falencia)
//		Text("Wow!").foregroundStyle(.black)
//		Text("Wow!").foregroundStyle(.black)
//		Text("Wow!").foregroundStyle(.black)
//		Text("Wow!").foregroundStyle(.black)
//		TagViewPickerComponentV1(currentTag: .constant(.trabalhista))
//		//		DropdownPicker()
//		TagViewPickerComponentV2(currentTag: .constant(.tributario))
//		TagViewPickerComponentV3(currentTag: .constant(.penal))
//		TagViewPickerComponentV4(currentTag: .constant(.civel))
//		TagViewPickerComponentV5(currentTag: .constant(.tributario))
//		Text("Wow!").foregroundStyle(.black)
//		Text("Wow!").foregroundStyle(.black)
//		Text("Wow!").foregroundStyle(.black)
//		Text("Wow!").foregroundStyle(.black)
//	}
//	.padding(100)
//	.background(Color.white)
//}
