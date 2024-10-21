//
//  ClientEmptyState.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 17/10/24.
//

import SwiftUI

struct ClientEmptyState: View {
    
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    
    var body: some View {
        ZStack {
            Image("clientEmptyStateBackground")
                .resizable()
//                .scaledToFill()
            VStack {
                if clients.count == 0 {
                    Text("Dê o primeiro passo para uma gestão \n jurídica mais eficiente!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.grayText)
                        .bold()
                    Button {
                        ShortCutsViewModel.shared.addClient.toggle()
                    } label: {
                        Text("Adicionar Cliente")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.arqBlack)
                } else {
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
