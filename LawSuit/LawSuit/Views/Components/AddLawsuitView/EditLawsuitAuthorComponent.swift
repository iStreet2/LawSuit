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
        
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(label)
                    .bold()
                Button(action: {
                    self.showingDetail.toggle()
                }, label: {
                    Text(button)
                })
                .foregroundStyle(.blue)
                .buttonStyle(.borderless)
                .sheet(isPresented: $showingDetail) {
                    SelectClientComponent(lawsuitAuthorName: $lawsuitAuthorName, lawsuitDefendantName: $lawsuitDefendantName, authorOrDefendant: $authorOrDefendant, screen: .small, attributedAuthor: $attributedAuthor, attributedDefendant: $attributedDefendant)   
                }
            }
        }
    }
}
