//
//  EditProcessAuthorComponent.swift
//  LawSuit
//
//  Created by Emily Morimoto on 23/08/24.
//

import SwiftUI

struct EditProcessAuthorComponent: View {
    
    @State var choosedClient: String = ""
    @State var showingDetail = false
    @State var button: String
    @State var label: String
    var screen: SizeEnumerator
    @Binding var lawsuit: ProcessMock
    @State var defendantOrClient: String
    
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
                .foregroundStyle(.blue)
                .sheet(isPresented: $showingDetail) {
                    ClientCheckboxIconComponent(lawsuit: $lawsuit, choosedClient: $choosedClient, screen: .small, defendantOrClient: $defendantOrClient)
                }
            }
        }
    }
}
//
//#Preview {
//    EditProcessAuthorComponent(button: "Alterar cliente", label: "Autor", screen: .small)
//}
