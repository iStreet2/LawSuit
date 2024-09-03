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
    @Binding var lawsuitParentAuthorName: String
    @Binding var lawsuitDefendant: String
    @State var defendantOrClient: String
    @Binding var attributedClient: Bool
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
                .buttonStyle(.borderless)
                .sheet(isPresented: $showingDetail) {
                    SelectClientComponent(lawsuitParentAuthorName: $lawsuitParentAuthorName, lawsuitDefendant: $lawsuitDefendant, defendantOrClient: $defendantOrClient, screen: .small, attributedClient: $attributedClient, attributedDefendant: $attributedDefendant)
                }
            }
        }
    }
}
