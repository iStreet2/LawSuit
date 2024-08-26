//
//  AddClientProgressView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

import SwiftUI

struct AddClientProgressView: View {
    
    @Binding var stage: Int
    
    var body: some View {
        VStack {
            HStack {
                ForEach(1...4, id: \.self) { index in
                    VStack {
                        Circle()
                            .fill(index <= stage ? Color.blue : Color.gray)
                            .frame(width: 10, height: 10)
                    }
                    if index < 4 {
                        Rectangle()
                            .fill(index < stage ? Color.blue : Color.gray)
                            .frame(height: 2)
                            .padding(.horizontal, -8)
                    }
                }
//                Button(action: {
//                    if stage < 4 {
//                        stage += 1
//                    }
//                }, label: {
//                    Text("Button")
//                })
            }
        }
        .frame(width: 300)
    }
}

//#Preview {
//    AddClientProgressView(stage: 1)
//}

