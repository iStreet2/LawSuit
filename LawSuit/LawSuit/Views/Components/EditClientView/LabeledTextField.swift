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
    
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .bold()
                .font(.body)
                .foregroundStyle(Color.black)
            TextField(placeholder, text: $textfieldText)
                .textFieldStyle(.roundedBorder)
        }
    }
}

//#Preview {
//    @State var text: String = ""
//    
//    return LabeledTextField(label: "Nome Completo", placeholder: "Nome Completo", textfieldText: $text)
//}
