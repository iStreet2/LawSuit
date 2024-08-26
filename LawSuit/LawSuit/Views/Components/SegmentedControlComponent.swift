//
//  SegmentedControlViewComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 26/08/24.
//

import SwiftUI

struct SegmentedControlComponent: View {
    @Binding var selectedOption: String
    var infos: [String]
    
    var body: some View {
        Picker("", selection: $selectedOption) {
            ForEach(infos, id: \.self) { info in
                Text(info).tag(info)
            }
        }
        .pickerStyle(.segmented)
        .colorMultiply(Color.segmentedControl)
        
        
    }
}

#Preview {
    NewProcessView()
}


//#Preview {
//    SegmentedControlComponent(selectedOption: <#T##Binding<String>#>, options: <#T##[String]#>, title: <#T##String#>)}
