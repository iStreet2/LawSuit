//
//  AddClientProgressView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

struct AddClientProgressView: View {
    
    @Binding var stage: Int
    
    let stageTexts = ["Dados Pessoais", "Endereço", "Contato", "Outros"]
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(1...4, id: \.self) { index in
                VStack {
                    Circle()
                        .fill(index <= stage ? Color(.wine) : Color.gray)
                        .frame(width: 10, height: 10)
                    Text(index == stage ? stageTexts[index - 1] : "")
                        .frame(width: 100)
                        .font(.callout)
                        .foregroundColor(Color.secondary)
                        .lineLimit(1)
                }
                if index < 4 {
                    Rectangle()
                        .fill(index < stage ? Color(.wine) : Color.gray)
                        .frame(height: 3)
                        .padding(.horizontal, -53)
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
