//
//  TelaTemporariaDoPaulo.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 28/08/24.
//

import SwiftUI

struct TelaTemporariaDoPaulo: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Text("Hello world")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                    }

                }
            }
    }
}

#Preview {
    TelaTemporariaDoPaulo()
}
