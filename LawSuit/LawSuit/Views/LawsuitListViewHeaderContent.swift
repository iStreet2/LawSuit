//
//  LawsuitListViewHeaderContent.swift
//  LawSuit
//
//  Created by Giovanna Micher on 04/09/24.
//

import SwiftUI

struct LawsuitListViewHeaderContent: View {
    var lawsuits: FetchedResults<Lawsuit>
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        
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
        .frame(minWidth: 777)
        .frame(height: 13)
        .font(.footnote)
        .bold()
        .foregroundStyle(Color(.gray))
        
        Divider()
        
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(lawsuits.enumerated()), id: \.offset) { index, lawsuit in
                    NavigationLink {
                        DetailedLawSuitView(lawsuit: lawsuit)
                    } label: {
                        LawsuitCellComponent(client: lawsuit.parentAuthor!, lawyer: lawsuit.parentLawyer!, lawsuit: lawsuit)
                            .background(Color(index % 2 == 0 ? .white : .gray).opacity(0.1))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
