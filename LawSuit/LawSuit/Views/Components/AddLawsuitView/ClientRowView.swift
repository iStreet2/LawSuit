//
//  ClientRowView.swift
//  LawSuit
//
//  Created by Emily Morimoto on 02/10/24.
//

import SwiftUI

struct ClientRowView: View {
    
    @Binding var clientRow: ClientRow
    @Binding var lawsuitAuthorName: String
    
    //    @State var attributedAuthor = false
    
    @State private var width = CGFloat.zero
    @State private var labelWidth =  CGFloat.zero
    
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(.tertiary.opacity(0.5))
                .border(.secondary.opacity(0.8))
            
            if clientRow == .selected {
                HStack{
                    Circle()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(.secondary.opacity(0.8))
                    Text("\(lawsuitAuthorName)")
                    Spacer()
                    
                    Button {
                        withAnimation {
                            lawsuitAuthorName = ""
                            clientRow = .notSelected
                        }
                    } label: {
                        Image(systemName: "minus")
                    }
                }
                .padding( 5)
                
                if clientRow == .notSelected {
                    HStack{
                        Circle()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.secondary.opacity(0.8))
                        RoundedRectangle(cornerRadius: 2)
                            .frame(width: 97, height: 13)
                            .foregroundStyle(.secondary.opacity(0.8))
                    }
                    .padding( 5)
                }
            }
        }
        .frame(width: 218, height: 53)
    }
}

//#Preview {
//    ClientRowView( lawsuitAuthorName: .constant("Hey"))
//}

enum ClientRow: String {
    case selected
    case notSelected
}
