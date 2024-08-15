//
//  CheckboxView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 14/08/24.
//

import SwiftUI

struct CheckboxView: View {
    
  
    
    var body: some View {
        VStack(alignment:.leading){
            
            Text("Solicitar documentos")
                .font(.title)
                .bold()
            
            Text("Cliente:")
                .font(.title3)
                .bold()
            
            Text("Documentos:")
                .font(.title3)
                .bold()
            
            CheckboxIconComponent()
            
          
        }
        .padding(40)
    }
}

#Preview {
    CheckboxView()
}
