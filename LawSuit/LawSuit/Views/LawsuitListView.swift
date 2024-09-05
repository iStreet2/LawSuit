//
//  ProcessListView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 28/08/24.
//

import SwiftUI

struct LawsuitListView: View {
    
    @State var createLawsuit = false
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    
    @State private var multiplier: Double = 0.5
    
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.managedObjectContext) var context
    
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Processos")
                        .font(.title)
                        .bold()
                    Button(action: {
                        createLawsuit.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color(.gray))
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(10)
                
                HStack(spacing: 0) {
                    Text("Nome e Número")
                        .font(.footnote)
                    Spacer()
                    Text("Tipo")
                        .font(.footnote)
                    Spacer()
                    Text("Última movimentação")
                        .font(.footnote)
                    Spacer()
                    Text("Cliente")
                        .font(.footnote)
                    Spacer()
                    Text("Advogado responsável")
                        .font(.footnote)
                }
                .padding(.horizontal, 10)
                .foregroundStyle(Color(.gray))
                
                Divider()
                    .padding(.top, 5)
                    .padding(.trailing, 10)
                
                if lawsuits.isEmpty {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("Sem processos")
                            .foregroundStyle(.gray)
                        Spacer()
                    }
                    Spacer()
                } else {
                    ScrollView {
                        VStack {
                            ForEach(Array(lawsuits.enumerated()), id: \.offset) { index, lawsuit in
                                NavigationLink {
                                    DetailedLawSuitView(lawsuit: lawsuit)
                                } label: {
                                    LawsuitCellComponent(client: lawsuit.parentAuthor!, lawyer: lawsuit.parentLawyer!, lawsuit: lawsuit)
                                        .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $createLawsuit, content: {
            AddLawsuitView()
        })
        .toolbar {
            ToolbarItem {
                Text("")
            }
        }
    }
}

#Preview {
    LawsuitListView()
}
