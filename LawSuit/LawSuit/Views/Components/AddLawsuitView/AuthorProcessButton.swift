//
//  AuthorProcessButton.swift
//  LawSuit
//
//  Created by Emily Morimoto on 27/08/24.
//

import SwiftUI

struct AuthorProcessButton: View {
    
    var label: String
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .bold()
                .font(.body)
                .foregroundStyle(Color.black)
            
        }
    }
}


#Preview {
    AuthorProcessButton(label: "Miika")
}
