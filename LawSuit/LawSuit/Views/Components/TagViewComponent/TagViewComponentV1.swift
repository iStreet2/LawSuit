//
//  TagViewComponentV1.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 01/09/24.
//

import SwiftUI

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
//		  .frame(width: 500, height: 500)
//		  .sheet(isPresented: ) { 
//			  <#code#>
//		  }
        
    }
}

#Preview {
	TagViewPickerComponentV1(currentTag: .constant(.ambiental))
}
