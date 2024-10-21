//
//  LawsuitsEmptyState.swift
//  LawSuit
//
//  Created by Gabriel Vicentin Negro on 17/10/24.
//

import SwiftUI

struct LawsuitsEmptyState: View {
    
    @ObservedObject var shortCutsViewModel = ShortCutsViewModel.shared
    @FetchRequest(sortDescriptors: []) var clients: FetchedResults<Client>
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    @Binding var addLawsuit: Bool
    
    var body: some View {
        ZStack {
            Image("lawsuitEmptyStateBackground")
                .resizable()
//                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                if clients.count == 0 {
                    Text("Dê o primeiro passo para uma gestão jurídica \n mais eficiente!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.grayText)
                        .bold()
                    Text("Para adicionar um processo, adicione um cliente primeiro")
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)
                    Button {
                        ShortCutsViewModel.shared.addClient.toggle()
                    } label: {
                        Text("Adicionar Cliente")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.arqBlack)
                } else {
                    Text("Comece a gerenciar seus processos!")
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .bold()
                        .foregroundStyle(.grayText)
                    Button {
                        addLawsuit.toggle()
                    } label: {
                        Text("Adicionar Processo")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.arqBlack)
                }
            }
        }
    }
}
