//
//  NotesBlock.swift
//  LawSuit
//
//  Created by Emily Morimoto on 23/10/24.
//

import SwiftUI

struct NoteBlock: View {
    @State private var width = CGFloat.zero
    @State private var labelWidth =  CGFloat.zero
    @Binding var note: String
    var placeholder: String
    
    var body: some View {
        HStack {
            TextField(placeholder, text: $note)
                .textFieldStyle(.plain)
                .foregroundStyle(.secondary)
                .padding(EdgeInsets(top: 11, leading: 7, bottom: 11, trailing: 7))
                .overlay {
                    GeometryReader { geo in
                        Color.clear.onAppear {
                            width = geo.size.width
                        }
                    }
                }
        }
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.secondary)
                    .shadow(color: .black.opacity(0.3), radius: 2.5)
            }
        }
    }
        
}

#Preview {
    NoteBlock(note: .constant("OL"), placeholder: "ss")
}
