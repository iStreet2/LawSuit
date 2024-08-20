////
////  PendentClientDocumentView.swift
////  LawSuit
////
////  Created by André Enes Pecci on 19/08/24.
////

import SwiftUI

struct PendentClientDocumentView: View {
    
    @State var clientsAndDocuments: [(name: String, document: String)] = [
        ("Daniela Flauto", "CPF"),
        ("Lucas Zanatta", "RG")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Aprovação Pendente")
                .font(.title2)
                .bold()
                .padding()
            ForEach(clientsAndDocuments, id: \.name) { item in
                PendentClientDocumentStyle(name: item.name, document: item.document)
            }
        }
        .padding(.bottom, 100)
        
        .frame(width: 370, height: 270)
    }
}

#Preview {
    PendentClientDocumentView()
}
