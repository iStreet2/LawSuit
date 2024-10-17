//
//  EditProcessAuthorComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 23/08/24.
//

import SwiftUI

struct EditLawsuitAuthorComponent: View {
    
    //MARK: Variáveis de estado
    @State var showingDetail = false
    @State var button: String
    @State var label: String
    @Binding var lawsuitAuthorName: String
    @Binding var lawsuitDefendantName: String
    @State var authorOrDefendant: String
    @Binding var attributedAuthor: Bool
    @Binding var attributedDefendant: Bool
    var required: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            if required {
                HStack(alignment: .top, spacing: 1) {
                    Text(label)
                        .bold()
                    Text("*")
                        .foregroundStyle(.wine)
                    Button(action: {
                        self.showingDetail.toggle()
                    }, label: {
                        Text(button)
                            .fontWeight(.semibold)
                    })
                    .foregroundStyle(Color(.wine))
                    .buttonStyle(.borderless)
                    .underline()
                    .sheet(isPresented: $showingDetail) {
                        SelectClientComponent(lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: $authorOrDefendant, screen: .small, attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                    }
                }
            } else {
                HStack{
                    Text(label)
                        .bold()
                    Button(action: {
                        self.showingDetail.toggle()
                    }, label: {
                        Text(button)
                            .fontWeight(.semibold)
                    })
                    .foregroundStyle(Color(.wine))
                    .buttonStyle(.borderless)
                    .underline()
                    .sheet(isPresented: $showingDetail) {
                        SelectClientComponent(lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: $authorOrDefendant, screen: .small, attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)
                    }
                }
                
            }
        }
    }
}
