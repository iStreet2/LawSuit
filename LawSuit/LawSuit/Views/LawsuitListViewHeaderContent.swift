//
//  LawsuitListViewHeaderContent.swift
//  LawSuit
//
//  Created by Giovanna Micher on 04/09/24.
//

import SwiftUI

struct LawsuitListViewHeaderContent: View {
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>

    var body: some View {
        HStack {
            Text("Nome e Número")
                .frame(width: 210, alignment: .leading)
                .padding(.leading, 20)
            Text("Tipo")
                .frame(width: 120, alignment: .leading)
            Text("Última Movimentação")
                .frame(width: 140, alignment: .leading)
            Text("Cliente")
                .frame(width: 140, alignment: .leading)
            Text("Advogado Responsável")
                .frame(width: 140, alignment: .leading)
        }
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
                        LawsuitCellComponent2(client: lawsuit.parentAuthor!, lawyer: lawsuit.parentLawyer!, lawsuit: lawsuit)
                            .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        } 
    }
}

#Preview {
    LawsuitListViewHeaderContent()
}
