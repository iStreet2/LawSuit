//
//  AddClientProgressView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

struct AddClientProgressView: View {
    
    @Binding var stage: Int
    
    let stageTexts = ["Dados Pessoais", "Endereço", "Contato"]
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(1...3, id: \.self) { index in
                VStack {
                    Circle()
                        .fill(index <= stage ? Color(.orange) : Color.gray)
                        .frame(width: 10, height: 10)
                    Text(index == stage ? stageTexts[index - 1] : "")
                        .frame(width: 80)
                        .font(.caption)
                        .foregroundColor(Color.secondary)
                        .lineLimit(1)
                }
                if index < 3 {
                    Rectangle()
                        .fill(index < stage ? Color(.orange) : Color.gray)
                        .frame(height: 2)
                        .padding(.horizontal, -43)
                        .padding(.vertical, 4)
                }
            }
        }
        .frame(width: 400)
    }
}

#Preview {
    AddClientProgressView(stage: .constant(2))
}
