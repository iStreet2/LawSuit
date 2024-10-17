////
////  TagViewComponentV4.swift
////  LawSuit
////
////  Created by Gabriel Vicentin Negro on 01/09/24.
////
//
//import SwiftUI
//
//struct TagViewPickerComponentV4: View {
//    
//    @Binding var currentTag: TagType
//    @State var stateCurrentTag: TagType = .trabalhista
//    @State var isShowingPickerView: Bool = false
//    
//    @State private var hoveredTag: TagType?
//    
//    let allTags = TagType.allCases
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            TagViewComponent(tagType: stateCurrentTag, isPicker: true)
//                .onTapGesture {
//                    withAnimation(.easeInOut(duration: 0.5)) {
//                        isShowingPickerView.toggle()
//                    }
//                }
////                .padding(.horizontal, isShowingPickerView ? 30 : 0)
////                .background(isShowingPickerView ? stateCurrentTag.tagColorBackground : .clear)
////                .clipShape(RoundedRectangle(cornerRadius: 45))
//            if (isShowingPickerView) {
//                VStack(alignment: .leading) {
//                    
//                    ForEach(allTags, id: \.self) { tag in
//                        VStack(alignment: .leading) {
//                            Text(tag.tagText)
//                                .foregroundStyle(hoveredTag == tag ? .gray : .black)
//                                .onTapGesture {
//                                    if #available(macOS 14.0, *) {
//                                        withAnimation(.easeInOut(duration: 0.5)) {
//                                            currentTag = tag
//                                            stateCurrentTag = tag
//                                        } completion: {
//                                            withAnimation(.easeInOut(duration: 0.5)) {
//                                                isShowingPickerView.toggle()
//                                            }
//                                        }
//                                    } else {
//                                        // Fallback on earlier versions
//                                        withAnimation(.easeInOut(duration: 0.5)) {
//                                            currentTag = tag
//                                            stateCurrentTag = tag
//                                            isShowingPickerView.toggle()
//                                        }
//                                    }
//                                }
//                            Divider()
//                        }
//                        .background(Color.clear)
//                        .onHover { hovering in
//                            withAnimation(.easeInOut(duration: 0.2)) {
//                                if hovering {
//                                    hoveredTag = tag
//                                } else {
//                                    hoveredTag = nil
//                                }
//                            }
//                        }
//                    }
//                    
//                }
//                .padding(.horizontal, 10)
//                .padding(.vertical, 5)
//                .padding(.top, 5)
//                .background(.tertiary)
//                .clipShape(RoundedRectangle(cornerRadius: 12))
//            }
//        }
//        .onAppear {
//            stateCurrentTag = currentTag
//        }
//    }
//}
//
//#Preview {
//	TagViewPickerComponentV4(currentTag: .constant(.ambiental))
//}
