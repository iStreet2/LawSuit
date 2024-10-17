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
        VStack {
            HStack(alignment: .top) {
                Button(action: {
                    print("Visualizado")
                }, label: {
                    Rectangle()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.quaternary)
                })
                .buttonStyle(.plain)
                VStack() {
                    HStack(alignment: .top) {
                        Text(name)
                            .lineLimit(2)
                            .font(.callout)
    
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
                    Spacer()
                
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
                                .padding(.horizontal)
                        })
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .padding(.horizontal)
            Divider()
        }
    }
}

#Preview {
    PendentDocumentStyleView(name: "RG")
}
