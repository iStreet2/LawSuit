//
//  PendentDocumentView.swift
//  LawSuit
//
//  Created by André Enes Pecci on 16/08/24.
//

import SwiftUI

struct PendentDocumentView: View {
    
    @State var documentName = ["Certidão de Casamento", "RG", "CNH", "CPF", "Certidão de Nascimento"]

    
    var body: some View {
        VStack( alignment: .leading) {
                        ForEach(documentName, id: \.self) { name in
                            PendentDocumentStyleView(name: name)
                        }
                    }
//        .padding()
    }
}

#Preview {
    PendentDocumentView()
}
