//
//  LabeledTextField.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

enum LabeledFieldType {
    case picker, date, textfield
}

struct LabeledField: View {
    @State var label: String
    @State var placeholder: String
    @State private var textfieldText: String = ""
    @State var labeledFieldType: LabeledFieldType
    @State var selectedDate = Date()
    
    init(label: String, placeholder: String, labeledFieldType: LabeledFieldType = .textfield) {
        self.label = label
        self.placeholder = placeholder
        self.labeledFieldType = labeledFieldType
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .bold()
                .font(.title3)
                .foregroundStyle(Color.black)
            if labeledFieldType == .textfield {
                TextField(placeholder, text: $textfieldText)
                    .textFieldStyle(.roundedBorder)
            } else if labeledFieldType == .picker {
                //insira aqui o picker
            } else if labeledFieldType == .date {
                DatePicker("Text", selection: $selectedDate)
                    .labelsHidden()
            }
        }
    }
}

#Preview {
    LabeledField(label: "Nome Completo", placeholder: "Nome Completo")
}
