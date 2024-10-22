//
//  TagViewPickerComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 07/10/24.
//

import SwiftUI

struct TagViewPickerComponent: View {
    
    @Binding var tagType: TagType
    let tagViewStyle: TagViewStyle
    var isPicker: Bool = false
    var cornerRadius: CGFloat = 45
    @State var wasTapped: Bool = false
    //    @EnvironmentObject var lawsuitViewModel: LawsuitViewModel
    //    var lawsuitType: String
    
    
    var body: some View {

        if tagViewStyle == .bullet {
            TagViewComponent(tagType: tagType)
        }
        
        if tagViewStyle == .picker {
            Picker("", selection: $tagType) {
                ForEach(TagType.allCases, id: \.self){ tag in
                    Text(tag.tagText)
                        .foregroundStyle(Color.black)
                        .tag(tag)
                }
            }
            .labelsHidden()
            .frame(width: 100)
            .pickerStyle(.automatic)
            .tint(.black)
        }
    }
}

