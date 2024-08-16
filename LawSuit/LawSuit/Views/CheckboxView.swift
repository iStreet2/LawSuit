//
//  CheckboxView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 15/08/24.
//

import SwiftUI

struct CheckboxView: View {
    var body: some View {
        
        
        
        VStack(alignment: .leading){
            Text("Solicitar documentos")
                .font(.title)
                .bold()
            
            Text("Ciente:")
                .font(.title3)
                .bold()
            ClientCheckboxIconComponent()
            
            Text("Documentos:")
                .font(.title3)
                .bold()
            
            HStack{
                CheckboxIconComponent()
                CheckboxIconComponent()
                CheckboxIconComponent()
            }
            
        }
        .padding(15)
        .background(.white)

    }
}

#Preview {
    CheckboxView()
}
