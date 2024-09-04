//
//  CheckboxIconComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct CheckboxIconComponent: View {
    
    @State var isPresented: Bool = false
    var files: String
    
    var body: some View {
        HStack{
            Toggle(isOn: $isPresented) {
                Text(files)
            }
        }
        .padding(30)
    }
}

//#Preview {
//    CheckboxIconComponent(.c)
//}
