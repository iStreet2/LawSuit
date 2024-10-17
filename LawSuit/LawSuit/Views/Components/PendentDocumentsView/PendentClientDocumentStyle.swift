//
//  PendentClientDocumentStyle.swift
//  LawSuit
//
//  Created by André Enes Pecci on 19/08/24.
//

import SwiftUI

struct PendentClientDocumentStyle: View {
    
    var name: String
    var document: String
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                HStack {
                    Image("DaniPhoto")
                        .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Text(name)
                        Text(document)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                Button(action: {
                    print("opa")
                }, label: {
                    Image(systemName: "chevron.right")
                        .padding()
                })
                .buttonStyle(.plain)
            }
            Divider()
        }
    }
}

#Preview {
    PendentClientDocumentStyle(name: "Daniela Flauto", document: "RG, CPF, CNH")
}
