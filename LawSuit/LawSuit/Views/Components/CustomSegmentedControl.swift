//
//  CustomSegmentedControl.swift
//  LawSuit
//
//  Created by Giovanna Micher on 27/08/24.
//

import SwiftUI

struct CustomSegmentedControl: View {
    @Binding var selectedOption: Int
    var options: [String]
    let color = Color("segmentedControl")
    
    var body: some View {
        HStack {
            ForEach(options.indices, id:\.self) { index in
                ZStack {
                    Rectangle()
                        .fill(color.opacity(0.3))
                    
                    Rectangle()
                        .fill(color)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    @State var selectedOption = 0
    return CustomSegmentedControl(selectedOption: $selectedOption, options: ["info","contato","outro"])
}
