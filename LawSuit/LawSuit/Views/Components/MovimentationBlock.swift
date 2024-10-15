//
//  MovimentationBlock.swift
//  LawSuit
//
//  Created by Giovanna Micher on 30/09/24.
//

import SwiftUI

struct MovimentationBlock: View {
    @EnvironmentObject var dataViewModel: DataViewModel
    @Environment(\.openURL) var openLink
    @ObservedObject var lawsuit: Lawsuit
    
    var body: some View {
        
            BoxView {
                VStack(alignment: .leading) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Última Movimentação")
                                .font(.title2)
                                .bold()
                            Text(dataViewModel.coreDataManager.updateManager.getLatestUpdateDate(lawsuit: lawsuit)?.convertToString() ?? "Sem movimentações")
                                .font(.title3)
                                .bold()
                            HStack {
                                Button(action: {
                                    openLink(URL(string: "https://www.jusbrasil.com.br/consulta-processual/")!)
                                }, label: {
                                    Text("Acessar JusBrasil")
                                })
                                .buttonStyle(.borderedProminent)
                                .tint(.black)
                            }
                            VStack(alignment: .leading, spacing: 5) {
                                Text("Movimentações Anteriores")
                                    .font(.headline)
                                    .foregroundStyle(Color(.secondaryLabelColor))
                                
                                ForEach(dataViewModel.coreDataManager.updateManager.sortUpdates(lawsuit: lawsuit).prefix(3)) { update in
                                    Text(update.date?.convertToString() ?? "Sem movimentações")
                                        .font(.subheadline)
                                        .foregroundStyle(Color(.secondaryLabelColor))
                                }
                            }
                            .padding(.top, 10)
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 3)
                }
            }
        }
    }

