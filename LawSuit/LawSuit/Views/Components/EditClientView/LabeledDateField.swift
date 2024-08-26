//
//  LabeledDateField.swift
//  LawSuit
//
//  Created by Giovanna Micher on 26/08/24.
//

import SwiftUI

struct LabeledDateField: View {
    @Binding var selectedDate: Date
    let label: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .bold()
                .font(.title3)
                .foregroundStyle(Color.black)
            DatePicker("Text", selection: $selectedDate)
                .labelsHidden()
        }
    }
}

#Preview {
    @State var data: Date = Date()
    
    return LabeledDateField(selectedDate: $data, label: "Data de Nascimento")
}
