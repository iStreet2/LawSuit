////
////  TagViewComponentV2.swift
////  LawSuit
////
////  Created by Gabriel Vicentin Negro on 01/09/24.
////
//
//import SwiftUI
//
//struct TagViewPickerComponentV2: View {
//    
//    @Binding var currentTag: TagType
//    @State var stateCurrentTag: TagType = .trabalhista
//    @State var isShowingPickerView: Bool = false
//    
//    let allTags: [TagType] = TagType.allCases
//    
//    var body: some View {
//        VStack {
//            TagViewComponent(tagViewStyle: <#TagViewStyle#>, tagType: stateCurrentTag, isPicker: true)
//                .onTapGesture {
//                    withAnimation {
//                        isShowingPickerView.toggle()
//                    }
//                }
//            if (isShowingPickerView) {
//                ForEach(allTags, id: \.self) { tag in
//                    TagViewComponent(tagType: tag)
//                        .onTapGesture {
//                            withAnimation {
//                                currentTag = tag
//                                stateCurrentTag = tag
//                                isShowingPickerView.toggle()
//                            }
//                        }
//                }
//            }
//        }
//        .onAppear {
//            stateCurrentTag = currentTag
//        }
//    }
//}
