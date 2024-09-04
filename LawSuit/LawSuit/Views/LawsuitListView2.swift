//
//  LawsuitListView2.swift
//  LawSuit
//
//  Created by Giovanna Micher on 03/09/24.
//

import SwiftUI

struct LawsuitListView2: View {
    
    @FetchRequest(sortDescriptors: []) var lawsuits: FetchedResults<Lawsuit>
    
    @EnvironmentObject var coreDataViewModel: CoreDataViewModel
    
    @Environment(\.managedObjectContext) var context
    
    @State var createProcess = false
    
    @State private var multiplier: Double = 0.5
        
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 10) {
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
                .border(Color.black)
                
                HStack(alignment: .top, spacing: 0) {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Nome e Número")
                            .font(.footnote)
                            .bold()
                            .foregroundStyle(Color(.gray))
                        
                        Divider()
                        ForEach(Array(lawsuits.enumerated()), id: \.offset) {
                            index, lawsuit in
                            NavigationLink {
                                DetailedLawSuitView(lawsuit: lawsuit)
                            } label: {
                                LawsuitNameCellComponent(lawsuit: lawsuit)
                                    .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(width: 210, alignment: .leading)
                    .border(Color.black)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Tipo")
                            .bold()
                            .font(.footnote)
                            .foregroundStyle(Color(.gray))

                        Divider()
                        ForEach(Array(lawsuits.enumerated()), id: \.offset) {
                            index, lawsuit in
                            NavigationLink {
                                DetailedLawSuitView(lawsuit: lawsuit)
                            } label: {
                                TagViewComponent(tagType: TagType(s: lawsuit.category ?? "trabalhista") ?? .trabalhista)
                                    .frame(width: 120, height: 47, alignment: .leading)
                                    .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))
                            }
        
                        }
                    }
                    .frame(width: 120, alignment: .leading)
                    .border(Color.black)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("Ultima movimentacao")
                            .font(.footnote)
                            .bold()
                            .foregroundStyle(Color(.gray))

                        Divider()
                        ForEach(Array(lawsuits.enumerated()), id: \.offset) {
                            index, lawsuit in
                            if let latestUpdateDate = coreDataViewModel.updateManager.getLatestUpdateDate(lawsuit: lawsuit) {
                                Text(formatDate(latestUpdateDate))
                                    .font(.callout)
                                    .bold()
                                    .frame(width: 140, height: 47, alignment: .leading)
                                    .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))

                            } else {
                                Text("Sem atualizações")
                                    .font(.callout)
                                    .bold()
                                    .frame(width: 140, height: 47, alignment: .leading)
                                    .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))


                            }
                        }
                    }
                    .frame(width: 140, alignment: .leading)
                    .border(Color.black)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Cliente")
                            .bold()
                            .font(.footnote)
                            .foregroundStyle(Color(.gray))

                        Divider()
                        ForEach(Array(lawsuits.enumerated()), id: \.offset) {
                            index, lawsuit in
                            Text(lawsuit.parentAuthor!.name)
                                .font(.callout)
                                .bold()
                                .frame(width: 140, height: 47, alignment: .leading)
                                .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))


                        }
                        
                    }
                    .frame(width: 140, alignment: .leading)
                    .border(Color.black)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("Advogado responsavel")
                            .font(.footnote)
                            .bold()
                            .foregroundStyle(Color(.gray))

                        Divider()
                        ForEach(Array(lawsuits.enumerated()), id: \.offset) {
                            index, lawsuit in
                            Text(lawsuit.parentLawyer!.name!)
                                .font(.callout)
                                .bold()
                                .frame(width: 140, height: 47, alignment: .leading)
                                .background(Color(index % 2 == 0 ? .gray : .white).opacity(0.1))


                        }
                    }
                    .frame(width: 140, alignment: .leading)
                    .border(Color.black)

                }
                .border(Color.black)
                Spacer()
            }
            .padding(10)
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
    
    func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy HH:mm"
            return formatter.string(from: date)
    }
}

#Preview {
    LawsuitListView2()
}
