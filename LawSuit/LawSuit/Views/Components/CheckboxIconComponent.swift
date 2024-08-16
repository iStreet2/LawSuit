//
//  CheckboxIconComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct CheckboxIconComponent: View {
    
    @State var isPresented: Bool = false
    @State var file = "RG"
    
    var body: some View {
        HStack{
                Toggle(isOn: $isPresented) {
                    Text(file)
            }
        }
        .padding(30)
    }
}

#Preview {
    CheckboxIconComponent()
}
