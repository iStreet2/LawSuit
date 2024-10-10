//
//  ClientRowView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 02/10/24.
//

import SwiftUI

struct ClientRowSelectView: View {
    
    @Binding var clientRowState: ClientRowStateEnum
    @Binding var lawsuitAuthorName: String
        
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.tertiary.opacity(0.05))
               .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.secondary.opacity(0.05), lineWidth: 1)
        )

            
            if clientRowState == .selected {
                HStack{
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.secondary.opacity(0.08))
                    Text("\(lawsuitAuthorName)")
                    Spacer()
                    
                    Button {
                        withAnimation {
                            lawsuitAuthorName = ""
                            clientRowState = .notSelected
                        }
                    } label: {
                        Image(systemName: "minus")
                    }
                }
                .padding( 5)
                
            } else if clientRowState == .notSelected {
                ClientRowNotSelectView()
                }
            }
        
        .frame(width: 218, height: 53)
    }
}

//#Preview {
//    ClientRowView( lawsuitAuthorName: .constant("Hey"))
//}

enum ClientRowStateEnum: String {
    case selected
    case notSelected
}
