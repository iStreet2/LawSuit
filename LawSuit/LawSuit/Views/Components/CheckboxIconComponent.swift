//
//  CheckboxIconComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct CheckboxIconComponent: View {
    
    @State var isSelected: Bool = false
    
    @State var fileNames = ["RG", "CPF", "CNH", "Certidão de nascimento", "Certidão de casamento", "Outro"]
    
    var body: some View {
        
        HStack{
            ForEach(fileNames, id:\.self) { file in
                HStack{
                    Toggle( isOn: $isSelected) {
                        Text(file)
                    }
                    .toggleStyle(.checkbox)
                }
                
            }
        }
        .padding(10)    }
}

#Preview {
    CheckboxIconComponent()
}
