//
//  LabeledTextField.swift
//  LawSuit
//
//  Created by Giovanna Micher on 23/08/24.
//

//import SwiftUI
//
//struct LabeledTextField: View {
//    let label: String
//    let placeholder: String
//    @Binding var textfieldText: String
//
//
//
//
//    var body: some View {
//
//        VStack(alignment: .leading, spacing: 4) {
//            Text(label)
//                .bold()
//                .font(.body)
//                .foregroundStyle(Color.black)
//            TextField(placeholder, text: $textfieldText)
//                .textFieldStyle(.roundedBorder)
//        }
//    }
//}

import SwiftUI

struct LabeledTextField: View {
    let label: String
    let placeholder: String
    @Binding var textfieldText: String
    
    @State private var width = CGFloat.zero
    @State private var labelWidth =  CGFloat.zero
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .bold()
                .font(.body)
                .foregroundStyle(Color.black)
            HStack {
                TextField(placeholder, text: $textfieldText)
                    .textFieldStyle(.plain)
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
                 
                        .foregroundStyle(.white)
                        .shadow(color: .black.opacity(0.3), radius: 2.5)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .trim(from: 0, to: 0.55)
                        .stroke(.wineOpacity, lineWidth: 1.5)
//                        .shadow(color: .black, radius: 5)
                    
                    RoundedRectangle(cornerRadius: 5)
                        .trim(from: 0.55 + (0.44 * (labelWidth / width)), to: 1)
                        .stroke(.wineOpacity,lineWidth: 1.5)
//                        .shadow(color: .black, radius: 5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
        }
        
    }
}




