//
//  LawsuitListViewHeaderContent.swift
//  LawSuit
//
//  Created by Giovanna Micher on 04/09/24.
//

import SwiftUI

struct LawsuitListViewHeaderContent: View {
    
    var lawsuits: FetchedResults<Lawsuit>
    @EnvironmentObject var navigationViewModel: NavigationViewModel
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                HStack {
                    Text("Nome e Número")
                        .frame(width: geo.size.width * 0.27, alignment: .leading)
                    
                    Text("Tipo")
                        .frame(width: geo.size.width * 0.12, alignment: .leading)
                    
                    Text("Última Movimentação")
                        .frame(width: geo.size.width * 0.17, alignment: .leading)
                    
                    Text("Cliente")
                        .frame(width: geo.size.width * 0.17, alignment: .leading)
                    
                    Text("Advogado Responsável")
                }
                .padding(.horizontal, 20)
            }
            .padding(.horizontal, 20)
        }
        .frame(minWidth: 777)
        .frame(height: 13)
        .font(.footnote)
        .bold()
        .foregroundStyle(Color(.gray))
        
        Divider()
        
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(lawsuits.enumerated()), id: \.offset) { index, lawsuit in
                    let lawsuitData = dataViewModel.coreDataManager.getClientAndEntity(for: lawsuit)

                    NavigationLink {
                        if let client = lawsuitData.client, let entity = lawsuitData.entity {
                            DetailedLawSuitView(lawsuit: lawsuit, client: client, entity: entity)
                        }
                    } label: {
                        if let client = lawsuitData.client {
                            LawsuitCellComponent(client: client, lawyer: lawsuit.parentLawyer!, lawsuit: lawsuit)
                                .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
                        } else {
                            Text("Carregando")
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}