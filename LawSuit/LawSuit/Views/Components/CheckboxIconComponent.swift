//
//  CheckboxIconComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct CheckboxIconComponent: View {
    
    @State var isChecked: Bool = false
    var text: String
    
    var body: some View {
        Toggle(isOn: $isChecked) {
            Text(text)
        }
        .toggleStyle(.checkbox)
    }
}

//#Preview {
//    CheckboxIconComponent(.c)
//}
