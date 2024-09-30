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
                .font(.body)
                .foregroundStyle(Color.black)
            DatePicker("Text", selection: $selectedDate, displayedComponents: .date)
                .labelsHidden()
        }
    }
}
