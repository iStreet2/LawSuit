//
//  PendentDocumentView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 16/08/24.
//

import SwiftUI

struct PendentDocumentView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var documentName = ["Certidão de Casamento", "RG", "CNH", "CPF", "Certidão de Nascimento", "Passaporte"]
    @State var pendentNumber: Int
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    HStack {
                        Text("\(pendentNumber)")
                            .foregroundStyle(.blue)
                            .bold()
                            .background() {
                                Circle()
                                    .scaledToFill()
                                    .foregroundStyle(.pendentNumber)
                                    .frame(width: 15)
                            }
                        Text("Aprovações Pendentes")
                            .foregroundStyle(.blue)
                            .bold()
                        Spacer()
                    }
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("closeButton")
                            .foregroundStyle(.secondary)
                    })
                    .buttonStyle(.plain)
                    .frame(width: 15)
                }
                .padding(.top, 5)
                .frame(width: 245)
                Divider()
                ScrollView {
                    VStack( alignment: .leading) {
                        ForEach(documentName, id: \.self) { name in
                            PendentDocumentStyleView(name: name)
                        }
                    }
                }
            }
            .frame(width: 260)
    }
}

#Preview {
    PendentDocumentView(pendentNumber: 9)
}
