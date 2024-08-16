//
//  PendentDocument.swift
//  LawSuit
//
//  Created by André Enes Pecci on 15/08/24.
//

import SwiftUI

struct PendentDocumentStyleView: View {
    
    var name: String
    
    var body: some View {
        
        HStack {
            
            Rectangle()
                .frame(width: 56, height: 56)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading) {
                HStack() {
                    Text(name)
                        .lineLimit(2)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    Button(action: {
                        print("Visualizado")
                    }, label: {
                        Text("Visualizar")
                            .foregroundStyle(.blue)
                    })
                    .buttonStyle(.plain)
                    .padding(.trailing, 10)
                }
                
                HStack {
                    Button(action: {
                        print("Recusado")
                    }, label: {
                        Text("Recusar")
                            .foregroundStyle(.red)
                    })
                    .buttonStyle(.plain)
                    
                    Spacer()
                    Button(action: {
                        print("Aprovado")
                    }, label: {
                        Text("Aprovar")
                            .font(.title3)
                            .tint(.blue)
                    })
                    .buttonStyle(.borderedProminent)
//                    .controlSize(.small)
                    .padding(.trailing, 5)
                    //                    .frame(width: 100)
                    
                }
            }
            
        }
        .frame(width: 235, height: 70)
    }
}

#Preview {
    PendentDocumentStyleView(name: "Certidão de Casamento")
}
