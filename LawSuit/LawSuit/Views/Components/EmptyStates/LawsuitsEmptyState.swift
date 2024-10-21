//
//  LawsuitsEmptyState.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 17/10/24.
//

import SwiftUI

struct LawsuitsEmptyState: View {
    
    //Fetch de clientes
    //Fetch de processos
    //Binding de toogle de adicionar cliente
    //Binding de toogle de adicionar processo
    
    var body: some View {
        ZStack {
            Image("clientEmptyStateBackground")
                .resizable()
                .scaledToFill()
            VStack {
                if true {
                    Text("Dê o primeiro passo para uma gestão \n jurídica mais eficiente!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.grayText)
                        .bold()
                    Button {
                        //Adicionar processo
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

#Preview {
    LawsuitsEmptyState()
}
