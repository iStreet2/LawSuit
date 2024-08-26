//
//  AddClientProgressView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 22/08/24.
//

//import SwiftUI
//
//struct AddClientProgressView: View {
//    
//    @Binding var stage: Int
//    
//    let stageTexts = ["Dados Pessoais", "Endereço", "Contato", "Outro"]
//    
//    var body: some View {
//        HStack(alignment: .top) {
//            ForEach(1...4, id: \.self) { index in
//                VStack(alignment: .center) {
//                    Circle()
//                        .fill(index <= stage ? Color.blue : Color.gray)
//                        .frame(width: 10, height: 10)
//                        .padding(.horizontal, 14)
//                    
//                    Text(stageTexts[index - 1])
//                        .frame(width: 80)
//                        .font(.caption)
//                        .foregroundColor(index <= stage ? Color.blue : Color.gray)
//                        .lineLimit(1)
//                        .border(.red)
//                   
//                }
//                if index < 4 {
//                    Rectangle()
//                        .fill(index < stage ? Color.blue : Color.gray)
//                        .frame(height: 2)
//                        .padding(.horizontal, -43)
//                        .padding(.vertical, 4)
//                }
//            }
//        }
//        .frame(width: 300)
//    }
//}
//
//#Preview {
//    AddClientProgressView(stage: .constant(1))
//}


//import SwiftUI
//
//struct AddClientProgressView: View {
//    
//    @Binding var stage: Int
//    
//    let stageTexts = ["Dados Pessoais", "Endereço", "Contato", "Outro"]
//    
//    var body: some View {
//        HStack(alignment: .top) {
//            ForEach(1...4, id: \.self) { index in
//                VStack {
//                    Circle()
//                        .fill(index <= stage ? Color.blue : Color.gray)
//                        .frame(width: 10, height: 10)
//                    
//                    if index == stage {
//                        Text(stageTexts[index - 1])
//                            .frame(width: 80)
//                            .font(.caption)
//                            .foregroundColor(Color.blue)
//                            .lineLimit(1)
//                    }
//                }
//                if index < 4 {
//                    Rectangle()
//                        .fill(index < stage ? Color.blue : Color.gray)
//                        .frame(height: 2)
//                        .padding(.horizontal, -43)
//                        .padding(.vertical, 4)
//                }
//            }
//        }
//        .frame(width: 300)
//    }
//}
//
//#Preview {
//    AddClientProgressView(stage: .constant(1))
//}

import SwiftUI

struct AddClientProgressView: View {
    
    @Binding var stage: Int
    
    let stageTexts = ["Dados Pessoais", "Endereço", "Contato", "Outro"]
    
    var body: some View {
        HStack(alignment: .top) {
            ForEach(1...4, id: \.self) { index in
                VStack {
                    Circle()
                        .fill(index <= stage ? Color.blue : Color.gray)
                        .frame(width: 10, height: 10)
                    Text(index == stage ? stageTexts[index - 1] : "")
                        .frame(width: 80)
                        .font(.caption)
                        .foregroundColor(Color.blue)
                        .lineLimit(1)
                }
                if index < 4 {
                    Rectangle()
                        .fill(index < stage ? Color.blue : Color.gray)
                        .frame(height: 2)
                        .padding(.horizontal, -43)
                        .padding(.vertical, 4)
                }
            }
        }
        .frame(width: 300)
    }
}

#Preview {
    AddClientProgressView(stage: .constant(1))
}
