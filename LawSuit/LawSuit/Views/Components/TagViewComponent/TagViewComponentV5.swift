//
//  TagViewComponentV5.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 01/09/24.
//

import SwiftUI

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
		  .frame(width: 500, height: 500)
    }
}

#Preview {
	TagViewPickerComponentV5(currentTag: .constant(.civel))
}
