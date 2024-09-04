//
//  TagViewComponentV3.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 01/09/24.
//

import SwiftUI

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
