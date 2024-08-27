//
//  LabeledPickerField.swift
//  LawSuit
//
//  Created by Giovanna Micher on 26/08/24.
//

import SwiftUI

struct LabeledPickerField: View {
    @Binding var selectedOption: String
    let arrayInfo: [String]
    let label: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .bold()
                .font(.body)
                .foregroundStyle(Color.black)
            
            Picker("", selection: $selectedOption) {
                ForEach(arrayInfo, id: \.self) {
                    Text($0)
                }
            }
            .labelsHidden()
        }
        
    }
}

#Preview {
    @State var selectedOption: String = ""
    return LabeledPickerField(selectedOption: $selectedOption, arrayInfo: ["MG","SP"], label: "Estado")
}
