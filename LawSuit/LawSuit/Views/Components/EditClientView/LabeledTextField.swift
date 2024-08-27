//
//  LabeledTextField.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

import SwiftUI

struct LabeledTextField: View {
    let label: String
    let placeholder: String
    @Binding var textfieldText: String
    
    init(label: String, placeholder: String, textfieldText: Binding<String>) {
        self.label = label
        self.placeholder = placeholder
        self._textfieldText = textfieldText
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .bold()
                .font(.title3)
                .foregroundStyle(Color.black)
            TextField(placeholder, text: $textfieldText)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    @State var text: String = ""
    
    return LabeledTextField(label: "Nome Completo", placeholder: "Nome Completo", textfieldText: $text)
}
