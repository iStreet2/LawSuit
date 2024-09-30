//
//  CheckboxIconComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct CheckboxIconComponent: View {
    
    @Binding var isChecked: Bool
    var text: String
    
    var body: some View {
        Toggle(isOn: $isChecked) {
            Text(text)
        }
        .toggleStyle(.checkbox)
    }
}
