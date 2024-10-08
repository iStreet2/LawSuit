////
////  TagViewComponentV1.swift
////  LawSuit
////
////  Created by Gabriel Vicentin Negro on 01/09/24.
////
//
//import SwiftUI
//
//struct TagViewPickerComponentV1: View {
//	
//	@Binding var currentTag: TagType
//	@State var stateCurrentTag: TagType = .trabalhista
//	@State var isShowingPickerView: Bool = false
//	
//	let tagTypes: [TagType] = TagType.allCases
//	
//	var body: some View {
//		VStack {
//			TagViewComponent(tagType: stateCurrentTag, isPicker: true)
//				.onTapGesture {
//					withAnimation {
//						isShowingPickerView.toggle()
//					}
//				}
//				.fixedSize(horizontal: true, vertical: false)
//		}
//		.frame(height: 20, alignment: .top)
//		.background(Color.white)
//		.clipShape(Rectangle())
//		.animation(.easeInOut, value: isShowingPickerView)
//		.onAppear {
//			stateCurrentTag = currentTag
//		}
//
//		.sheet(isPresented: $isShowingPickerView) {
//			ForEach(tagTypes, id:\.self) { tag in
//				TagViewComponent(tagType: tag)
//					.onTapGesture {
//						withAnimation {
//							isShowingPickerView.toggle()
//							currentTag = tag
//							stateCurrentTag = tag
//						}
//					}
//			}
//			.transition(.move(edge: .top))
//			.zIndex(1)
//			.clipped()
//			.padding()
//		}
//		
//	}
//}
//
//#Preview {
//	TagViewPickerComponentV1(currentTag: .constant(.ambiental))
//}
