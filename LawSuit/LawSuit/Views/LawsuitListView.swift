//
//  ProcessListView.swift
//  LawSuit
//
//  Created by Giovanna Micher on 28/08/24.
//

import SwiftUI

struct LawsuitListView: View {
    
    @State var createProcess = false
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    
    @EnvironmentObject var mockViewModel: MockViewModel
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("Processos")
                        .font(.title)
                        .bold()
                    Button(action: {
                        createProcess.toggle()
                    }, label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundStyle(Color(.gray))
                    })
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(10)
                HStack {
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
            .sheet(isPresented: $createProcess, content: {
                AddLawsuitView()
            })
            .toolbar {
                ToolbarItem {
                    Text("")
                }
            }
        }
    }
}


//#Preview {
//    ProcessListView()
//}
