//
//  ClientEmptyState.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 17/10/24.
//

import SwiftUI

struct ClientEmptyState: View {
    
    @State var state: clientEmptyState
    @Binding var addClient: Bool
    
    
    var body: some View {
        
        if state == .haveNoClients {
            ZStack {
                Image("clientEmptyStateBackground")
                    .resizable()
                    .scaledToFill()
                VStack {
                    Text("Dê o primeiro passo para uma gestão \n jurídica mais eficiente!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.grayText)
                        .bold()
                    Button {
                        addClient.toggle()
                    } label: {
                        Text("Adicionar Cliente")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.arqBlack)
                }
            }
        } else {
            ZStack {
                Image("clientEmptyStateBackground")
                    .resizable()
                    .scaledToFill()
                VStack {
                    Text("Selecione um cliente")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .bold()
                        .foregroundStyle(.grayText)
                }
            }
        }
    }
}

enum clientEmptyState: String {
    case haveNoClients
    case haveClients
}
