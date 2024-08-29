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
            }
                if showingDetail {
                    ClientCheckboxIconComponent(choosedClient: $choosedClient, screen: .small)
                    
                }
               
                
                
            
            
            
            Text(choosedClient)
        }
//        .padding(200)
        
    }
    
}

#Preview {
    EditProcessAuthorComponent(button: "Alterar cliente", label: "Autor", screen: .small)
}
