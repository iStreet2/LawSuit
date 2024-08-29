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
        .pickerStyle(.segmented).foregroundStyle(Color(.segmentedControl))
        .pickerStyle(SegmentedPickerStyle()).foregroundColor(Color.orange)
    }
}

#Preview {
    NewProcessView()
}
