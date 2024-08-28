//
//  TagViewComponent.swift
//  LawSuit
//
//  Created by Paulo Sonzzini Ribeiro de Souza on 27/08/24.
//

import Foundation
import SwiftUI

enum TagType: CaseIterable, Identifiable {
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
	var isPicker: Bool = false
	var cornerRadius: CGFloat = 45
	@State var wasTapped: Bool = false
	
	var body: some View {
		HStack(spacing: 4) {
			Text(tagType.tagText)
				.font(.callout)
				.bold()
				.foregroundStyle(tagType.tagColorForeground)
				.fixedSize(horizontal: true, vertical: true)
			if isPicker {
				Image(systemName: "chevron.up.chevron.down")
					.foregroundStyle(tagType.tagColorForeground)
			}
		}
		.padding(.vertical, 1)
		.padding(.horizontal, (wasTapped && isPicker) ? 30 : 10)
		.background(
			tagType.tagColorBackground
				.clipShape(RoundedRectangle(cornerRadius: cornerRadius))
		)
	}
}

struct TagViewPickerComponentV1: View {
	
	@Binding var currentTag: TagType
	@State var stateCurrentTag: TagType = .trabalhista
	@State var isShowingPickerView: Bool = false
	
	let tagTypes: [TagType] = TagType.allCases
	
	var body: some View {
		VStack {
			TagViewComponent(tagType: stateCurrentTag, isPicker: true)
				.onTapGesture {
					withAnimation {
						isShowingPickerView.toggle()
					}
				}
				.fixedSize(horizontal: true, vertical: false)
			if isShowingPickerView {
				ForEach(tagTypes, id:\.self) { tag in
					TagViewComponent(tagType: tag)
						.onTapGesture {
							withAnimation {
								isShowingPickerView.toggle()
								currentTag = tag
								stateCurrentTag = tag
							}
						}
				}
				.transition(.move(edge: .top))
				.zIndex(1)
				.clipped()
			}
		}
		.frame(height: isShowingPickerView ? .infinity : 20, alignment: .top)
		.background(Color.white)
		.clipShape(Rectangle())
		.animation(.easeInOut, value: isShowingPickerView)
		.onAppear {
			stateCurrentTag = currentTag
		}
		
	}
}

struct TagViewPickerComponentV2: View {
	
	@Binding var currentTag: TagType
	@State var stateCurrentTag: TagType = .trabalhista
	@State var isShowingPickerView: Bool = false
	
	let allTags: [TagType] = TagType.allCases
	
	var body: some View {
		VStack {
			TagViewComponent(tagType: stateCurrentTag, isPicker: true)
				.onTapGesture {
					withAnimation {
						isShowingPickerView.toggle()
					}
				}
			if (isShowingPickerView) {
				ForEach(allTags, id: \.self) { tag in
					TagViewComponent(tagType: tag)
						.onTapGesture {
							withAnimation {
								currentTag = tag
								stateCurrentTag = tag
								isShowingPickerView.toggle()
							}
						}
				}
			}
		}
		.onAppear {
			stateCurrentTag = currentTag
		}
	}
}

struct TagViewPickerComponentV3: View {
	
	@Binding var currentTag: TagType
	@State var stateCurrentTag: TagType = .trabalhista
	@State var isShowingPickerView: Bool = false
	
	let tagTypes: [TagType] = TagType.allCases
	
	var body: some View {
		VStack {
			TagViewComponent(tagType: stateCurrentTag, isPicker: true)
				.onTapGesture {
					withAnimation(.easeInOut(duration: 0.5)) {
						isShowingPickerView.toggle()
					}
				}
			if isShowingPickerView {
				ForEach(tagTypes, id:\.self) { tag in
					TagViewComponent(tagType: tag)
						.onTapGesture {
							
							if #available(macOS 14.0, *) {
								withAnimation(.easeInOut(duration: 0.5)) {
									self.currentTag = tag
									self.stateCurrentTag = tag
									
								} completion: {
									withAnimation(.easeInOut(duration: 0.5)) {
										isShowingPickerView.toggle()
									}
								}
							} else {
								// Fallback on earlier versions
								withAnimation(.easeInOut(duration: 0.5)) {
									self.currentTag = tag
									self.stateCurrentTag = tag
									isShowingPickerView.toggle()
								}
							}
						}
					
				}
			}
		}
		.onAppear {
			stateCurrentTag = currentTag
		}
	}
}

struct TagViewPickerComponentV4: View {
	
	@Binding var currentTag: TagType
	@State var stateCurrentTag: TagType = .trabalhista
	@State var isShowingPickerView: Bool = false
	
	@State private var hoveredTag: TagType?
	
	let allTags = TagType.allCases
	
	var body: some View {
		VStack(spacing: 0) {
			TagViewComponent(tagType: stateCurrentTag, isPicker: true)
				.onTapGesture {
					withAnimation(.easeInOut(duration: 0.5)) {
						isShowingPickerView.toggle()
					}
				}
//				.padding(.horizontal, isShowingPickerView ? 30 : 0)
//				.background(isShowingPickerView ? stateCurrentTag.tagColorBackground : .clear)
//				.clipShape(RoundedRectangle(cornerRadius: 45))
			if (isShowingPickerView) {
				VStack(alignment: .leading) {
					
					ForEach(allTags, id: \.self) { tag in
						VStack(alignment: .leading) {
							Text(tag.tagText)
								.foregroundStyle(hoveredTag == tag ? .gray : .black)
								.onTapGesture {
									if #available(macOS 14.0, *) {
										withAnimation(.easeInOut(duration: 0.5)) {
											currentTag = tag
											stateCurrentTag = tag
										} completion: {
											withAnimation(.easeInOut(duration: 0.5)) {
												isShowingPickerView.toggle()
											}
										}
									} else {
										// Fallback on earlier versions
										withAnimation(.easeInOut(duration: 0.5)) {
											currentTag = tag
											stateCurrentTag = tag
											isShowingPickerView.toggle()
										}
									}
								}
							Divider()
						}
						.background(Color.clear)
						.onHover { hovering in
							withAnimation(.easeInOut(duration: 0.2)) {
								if hovering {
									hoveredTag = tag
								} else {
									hoveredTag = nil
								}
							}
						}
					}
					
				}
				.padding(.horizontal, 10)
				.padding(.vertical, 5)
				.padding(.top, 5)
				.background(.tertiary)
				.clipShape(RoundedRectangle(cornerRadius: 12))
			}
		}
		.onAppear {
			stateCurrentTag = currentTag
		}
	}
}

struct TagViewPickerComponentV5: View {

	@Environment(\.defaultMinListRowHeight) var listRowHeight
	
	@Binding var currentTag: TagType
	@State var stateCurrentTag: TagType = .trabalhista
	@State var isShowingPickerView: Bool = false

	@State private var hoveredTag: TagType?
	
	let allTags: [TagType] = TagType.allCases
	
	
	var body: some View {
		VStack {
			TagViewComponent(tagType: stateCurrentTag, isPicker: true)
				.onTapGesture {
					withAnimation(.easeInOut(duration: 0.5)) {
						isShowingPickerView.toggle()
					}
				}
			if isShowingPickerView {
				List(allTags) { tag in
					VStack {
						Text(tag.tagText)
							.foregroundStyle(hoveredTag == tag ? tag.tagColorForeground : .white)
					}
					.onHover { hovering in
						withAnimation(.easeInOut(duration: 0.2)) {
							if hovering {
								hoveredTag = tag
							} else {
								hoveredTag = nil
							}
						}
					}
					.onTapGesture {
						if #available(macOS 14.0, *) {
							withAnimation(.easeInOut(duration: 0.5)) {
								currentTag = tag
								stateCurrentTag = tag
							} completion: {
								withAnimation(.easeInOut(duration: 0.5)) {
									isShowingPickerView.toggle()
								}
							}
						} else {
							// Fallback on earlier versions
							withAnimation(.easeInOut(duration: 0.5)) {
								currentTag = tag
								stateCurrentTag = tag
								isShowingPickerView.toggle()
							}
						}
					}
				}
				.frame(width: 150, height: listRowHeight * CGFloat(allTags.count) + 20)
				.clipShape(RoundedRectangle(cornerRadius: 12))
			}
		}
		.onAppear {
			stateCurrentTag = currentTag
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

#Preview {
	VStack {
		//		TagViewComponent(tagType: .falencia)
		Text("Wow!").foregroundStyle(.black)
		Text("Wow!").foregroundStyle(.black)
		Text("Wow!").foregroundStyle(.black)
		Text("Wow!").foregroundStyle(.black)
		TagViewPickerComponentV1(currentTag: .constant(.trabalhista))
		//		DropdownPicker()
		TagViewPickerComponentV2(currentTag: .constant(.tributario))
		TagViewPickerComponentV3(currentTag: .constant(.penal))
		TagViewPickerComponentV4(currentTag: .constant(.civel))
		TagViewPickerComponentV5(currentTag: .constant(.tributario))
		Text("Wow!").foregroundStyle(.black)
		Text("Wow!").foregroundStyle(.black)
		Text("Wow!").foregroundStyle(.black)
		Text("Wow!").foregroundStyle(.black)
	}
	.padding(100)
	.background(Color.white)
}
